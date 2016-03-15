require_relative 'helper'
require 'fluent/formatter'
require 'fluent/plugin/formatter_sprintf'

class SprintfFormatterTest < ::Test::Unit::TestCase
  def setup
    @formatter = Fluent::Plugin.new_formatter('sprintf')
    @time = Fluent::Engine.now
  end

  def create_driver(conf={})
    Fluent::Test::FormatterTestDriver.new(Fluent::TextFormatter::SprintfFormatter).configure(conf)
  end

  def configure(conf)
    @formatter = create_driver(conf)
  end

  def test_format_space
    configure({'sprintf_format' => "${tag} ${url} ${ip_address}\n"})
    tag = 'file.test'
    record = {"url" => "/", "ip_address" => "127.0.0.1"}

    formatted = @formatter.format(tag, @time, record)
    assert_equal("file.test / 127.0.0.1\n", formatted)
  end

  def test_format_tsv
    configure({'sprintf_format' => "${tag}\t${url}\t${ip_address}\n"})
    tag = 'file.test'
    record = {"url" => "/", "ip_address" => "127.0.0.1"}

    formatted = @formatter.format(tag, @time, record)
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
end
