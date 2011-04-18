class Pru
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  def self.map(io, code)
    String.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def _pru(i)
        #{code}
      end
    RUBY

    i = 1
    io.readlines.each do |line|
      result = line[0..-2]._pru(i)
      if result == true
        yield line
      elsif result.is_a?(Regexp)
        yield line if line =~ result
      elsif result
        yield result
      end
      i += 1
    end
  end

  def self.reduce(array, code)
    Array.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def _pru
        #{code}
      end
    RUBY
    array._pru
  end
end

# http://madeofcode.com/posts/74-ruby-core-extension-array-sum
class Array
  def sum(method = nil, &block)
    if block_given?
      raise ArgumentError, "You cannot pass a block and a method!" if method
      inject(0) { |sum, i| sum + yield(i) }
    elsif method
      inject(0) { |sum, i| sum + i.send(method) }
    else
      inject(0) { |sum, i| sum + i }
    end
  end
end

class Array
  def mean(method = nil, &block)
    sum(method, &block) / size.to_f
  end
end
