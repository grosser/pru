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

    # Yield items from a JSON stream. In k8s mode, if the first value has an
    # "items" key (e.g. `kubectl get ... -o json`) its elements are yielded instead.
    def each_json_item(io, k8s: false)
      return enum_for(:each_json_item, io, k8s: k8s) unless block_given?
      first = true
      each_json(io) do |item|
        if k8s && first && item.is_a?(Hash) && item.key?("items")
          item.fetch("items").each { |i| yield i }
        else
          yield item
        end
        first = false
      end
    end

    private

    def compile(code)
      eval("proc { |i| #{code} }", TOPLEVEL_BINDING, __FILE__, __LINE__)
    end

    # Parse a stream of concatenated JSON values (newline-delimited or multiline)
    # by accumulating lines until the buffer forms a complete value.
    def each_json(io)
      require 'json'
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
