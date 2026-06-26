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

    # An enumerable of items parsed from a JSON stream. In k8s mode, if a value
    # has an "items" key (e.g. `kubectl get ... -o json`) its elements are the items instead.
    def json_items(io, k8s: false)
      Enumerator.new do |yielder|
        each_json(io) do |item|
          if k8s && item.is_a?(Hash) && item.key?("items")
            item.fetch("items").each { |i| yielder << i }
          else
            yielder << item
          end
        end
      end
    end

    private

    def compile(code)
      eval("proc { |i| #{code} }", TOPLEVEL_BINDING, __FILE__, __LINE__)
    end

    # Parse a stream of concatenated JSON values (newline-delimited or multiline)
    # by accumulating lines until the buffer forms a complete value.
    # TODO: this is not very efficient, but keeping track of opening/closing braces might be ugly too
    def each_json(io)
      buffer = +""
      io.each_line do |line|
        buffer << line
        begin
          item = JSON.parse(buffer)
        rescue JSON::ParserError
          next
        end
        yield item
        buffer = +""
      end
      raise JSON::ParserError, "unexpected trailing input: #{buffer.strip}" unless buffer.strip.empty?
    end
  end
end
