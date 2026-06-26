require 'pru/core_ext/array'

module Pru
  class << self
    def map(io, code)
      String.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def _pru(i)
          #{code}
        end
      RUBY

      i = 0
      io.each_line do |line|
        i += 1
        line.chomp!
        result = line._pru(i) or next

        case result
        when true then yield line
        when Regexp then yield line if line =~ result
        else yield result
        end
      end
    end

    def reduce(array, code)
      Array.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def _pru
          #{code}
        end
      RUBY
      array._pru
    end

    def json_map(io, code, k8s: false)
      block = compile(code)
      i = 0
      each_item(io, k8s) do |item|
        i += 1
        result = item.instance_exec(i, &block) or next

        case result
        when true then yield item
        else yield result
        end
      end
    end

    def json_reduce(array, code)
      array.instance_exec(&compile(code))
    end

    private

    def compile(code)
      eval("proc { |i| #{code} }", TOPLEVEL_BINDING, __FILE__, __LINE__)
    end

    # Yield items from a JSON stream. In k8s mode, if the first value has an
    # "items" key (e.g. `kubectl get ... -o json`) its elements are yielded instead.
    def each_item(io, k8s)
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
