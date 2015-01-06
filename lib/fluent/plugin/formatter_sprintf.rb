module Fluent
  module TextFormatter
    class SprintfFormatter < Formatter
      Plugin.register_formatter('sprintf', self)

      include Configurable
      include HandleTagAndTimeMixin

      config_param :sprintf_format, :string

      def initialize
        super
      end

      def configure(conf)
        super
        @time_format = @time_format || '%Y-%m-%d %H:%M:%S'
        r = /\$\{([^}]+)\}/
        @keys = @sprintf_format.scan(r).map{ |key| key.first }
        @sprintf_format = @sprintf_format.gsub(/\$\{([^}]+)\}/, '%s')
        begin
          @sprintf_format % @keys
        rescue ArgumentError => e
          raise Fluent::ConfigError, "formatter_sprintf: @sprintf_format is can't include '%'"
        end
      end

      def format(tag, time, record)
        values = @keys.map{ |key| 
          if key == 'tag'
            tag
          elsif key == 'time'
            Time.at(time).strftime(@time_format)
          else
            record[key] 
          end
        }
        @sprintf_format % values
      end
    end
  end
end
