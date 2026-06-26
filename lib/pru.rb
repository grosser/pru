require 'pru/core_ext/array'

module Pru
  class << self
    def map(items, code)
      block = compile(code)
      i = 0
      items.each do |item|
        i += 1
        result = item.instance_exec(i, &block) || next

        case result
        when true then yield item
        when Regexp then yield item if item =~ result
        else yield result
        end
      end
    end

    def reduce(array, code)
      array.instance_exec(&compile(code))
    end

    # An enumerable of JSON values parsed from a stream (newline-delimited or multiline),
    # parsed lazily so we process as input arrives, by accumulating lines until the buffer
    # forms a complete value.
    # TODO: this is not very efficient, but keeping track of opening/closing braces might be ugly too
    def each_json(io)
      Enumerator.new do |yielder|
        buffer = +""
        io.each_line do |line|
          buffer << line
          begin
            item = JSON.parse(buffer)
          rescue JSON::ParserError
            next
          end
          yielder << item
          buffer = +""
        end
        raise JSON::ParserError, "unexpected trailing input: #{buffer.strip}" unless buffer.strip.empty?
      end
    end

    private

    def compile(code)
      eval("proc { |i| #{code} }", TOPLEVEL_BINDING, __FILE__, __LINE__)
    end
  end
end
