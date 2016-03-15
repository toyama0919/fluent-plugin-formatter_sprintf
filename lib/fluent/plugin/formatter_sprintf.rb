module Fluent
  module TextFormatter
    class SprintfFormatter < Formatter
      Plugin.register_formatter('sprintf', self)

      include Configurable
      include HandleTagAndTimeMixin

      config_param :sprintf_format, :string
      config_param :sprintf_blank_string, :string, :default => nil
      config_param :sprintf_blank_record_format, :string, :default => nil

      def initialize
        super
      end

      def configure(conf)
        super
        @time_format = @time_format || '%Y-%m-%d %H:%M:%S'
        r = /\$\{([^}]+)\}/
        @keys = @sprintf_format.scan(r).map{ |key| key.first }
        @sprintf_format = @sprintf_format.gsub(/\$\{([^}]+)\}/, '%s')
        if @sprintf_blank_record_format
          @sprintf_blank_record_keys = @sprintf_blank_record_format.scan(r).map{ |key| key.first }
          @sprintf_blank_record_format = @sprintf_blank_record_format.gsub(/\$\{([^}]+)\}/, '%s')
        end

        begin
          @sprintf_format % @keys
        rescue ArgumentError => e
          raise Fluent::ConfigError, "formatter_sprintf: @sprintf_format is can't include '%'"
        end
      end

      def format(tag, time, record)
        if record.empty? && @sprintf_blank_record_format
          return @sprintf_blank_record_format % get_values(@sprintf_blank_record_keys, tag, time, record)
        end
        @sprintf_format % get_values(@keys, tag, time, record)
      end

      def get_values(keys, tag, time, record)
        keys.map{ |key|
          get_value(key, tag, time, record)
        }
      end

      def get_value(key, tag, time, record)
        if key == 'tag'
          tag
        elsif key == 'time'
          Time.at(time).strftime(@time_format)
        else
          return @sprintf_blank_string if record[key].nil?
          if record[key].respond_to?(:empty?) && record[key].empty?
            return @sprintf_blank_string
          end
          if record[key].class == String && record[key].strip.empty?
            return @sprintf_blank_string
          end
          record[key]
        end
      end
    end
  end
end
