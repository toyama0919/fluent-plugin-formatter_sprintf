require_relative 'helper'
require 'fluent/test/driver/formatter'
require 'fluent/formatter'
require 'fluent/plugin/formatter_sprintf'

class SprintfFormatterTest < ::Test::Unit::TestCase
  def setup
    @formatter = Fluent::Plugin.new_formatter('sprintf')
    @time = Fluent::Engine.now
  end

  def create_driver(conf={})
    Fluent::Test::Driver::Formatter.new(Fluent::Plugin::SprintfFormatter).configure(conf)
  end

  def configure(conf)
    @formatter = create_driver(conf)
  end

  def test_format_space
    configure({'sprintf_format' => "${tag} ${url} ${ip_address}\n"})
    tag = 'file.test'
    record = {"url" => "/", "ip_address" => "127.0.0.1"}

    formatted = @formatter.instance.format(tag, @time, record)
    assert_equal("file.test / 127.0.0.1\n", formatted)
  end

  def test_format_tsv
    configure({'sprintf_format' => "${tag}\t${url}\t${ip_address}\n"})
    tag = 'file.test'
    record = {"url" => "/", "ip_address" => "127.0.0.1"}

    formatted = @formatter.instance.format(tag, @time, record)
    assert_equal("file.test\t/\t127.0.0.1\n", formatted)
  end

  def test_format_literal_error
    assert_raise(Fluent::ConfigError) do
      configure({'sprintf_format' => "%s\t${url}\t${ip_address}\n"})
    end    

    assert_raise(Fluent::ConfigError) do
      configure({'sprintf_format' => "${url}\t${ip_address}\t%s"})
    end    

    assert_raise(Fluent::ConfigError) do
      configure({'sprintf_format' => "${url}\t%s\t${ip_address}\t"})
    end    
  end

  def test_fixnum
    configure({'sprintf_format' => "${tag}\t${id}\t${ip_address}\n"})
    tag = 'file.test'
    record = {"id" => 1, "ip_address" => "127.0.0.1"}

    formatted = @formatter.instance.format(tag, @time, record)
    assert_equal("file.test\t1\t127.0.0.1\n", formatted)
  end

  def test_sprintf_blank_string
    configure(
      {
        'sprintf_format' => "${tag}\t${id}\t${ip_address}\t${space}\n",
        'sprintf_blank_string' => "-",
      }
    )
    tag = 'file.test'
    record = {"id" => nil, "ip_address" => "", "space" => " "}

    formatted = @formatter.instance.format(tag, @time, record)
    assert_equal("file.test\t-\t-\t-\n", formatted)
  end

  def test_sprintf_blank_string_with_array
    configure(
      {
        'sprintf_format' => "${tag}\t${array}\n",
        'sprintf_blank_string' => "-",
      }
    )
    tag = 'file.test'
    record = {"array" => []}

    formatted = @formatter.instance.format(tag, @time, record)
    assert_equal("file.test\t-\n", formatted)
  end

  def test_sprintf_blank_record_format
    configure(
      {
        'sprintf_format' => "${tag}\t${id}\t${ip_address}\t${space}\n",
        'sprintf_blank_string' => "-",
        'sprintf_blank_record_format' => "---\n",
      }
    )
    tag = 'file.test'
    record = {}

    formatted = @formatter.instance.format(tag, @time, record)
    assert_equal("---\n", formatted)
  end
end
