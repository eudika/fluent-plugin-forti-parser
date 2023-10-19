## parser_forti.rb
require 'fluent/plugin/parser'
require 'shellwords'

module Fluent
  module Plugin
    class MyAwesomeInput < Parser
      # For `@type forti` in configuration file
      Fluent::Plugin.register_parser('forti', self)

      config_param :reserve_time, :bool, default: false

      def configure(conf)
        super

        @time_parser = Fluent::TimeParser.new("%Y-%m-%d %H:%M:%S %z")
        @reserve_time = conf['reserve_time']
      end

      def parse(text)
        record = text_to_hash(text)

        time = parse_time record['date'], record['time'], record['tz']
        if not @reserve_time
          record.delete('date')
          record.delete('time')
          record.delete('tz')
        end

        yield time, record
      end

      def text_to_hash(text)
        segments = Shellwords::shellwords(text)

        hash = {}
        segments.each do |seg|
          key, value = seg.split('=', 2)
          hash[key] = value
        end
        return hash
      end

      def parse_time(date, time, tz)
        time_text = [date, time, tz].join(" ")
        return @time_parser.parse(time_text)
      end
    end
  end
end
