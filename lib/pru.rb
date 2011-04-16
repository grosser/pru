class Pru
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  def self.map(io, code)
    io.readlines.each do |line|
      result = line.instance_exec{ eval(code) }
      if result == true
        yield line
      elsif result.is_a?(Regexp)
        yield line if line =~ result
      elsif result
        yield result
      end
    end
  end

  def self.reduce(array, code)
    array.instance_exec{ eval(code) }
  end
end

class Object
  unless defined? instance_exec # 1.9
    module InstanceExecMethods #:nodoc:
    end
    include InstanceExecMethods

    # Evaluate the block with the given arguments within the context of
    # this object, so self is set to the method receiver.
    #
    # From Mauricio's http://eigenclass.org/hiki/bounded+space+instance_exec
    def instance_exec(*args, &block)
      begin
        old_critical, Thread.critical = Thread.critical, true
        n = 0
        n += 1 while respond_to?(method_name = "__instance_exec#{n}")
        InstanceExecMethods.module_eval { define_method(method_name, &block) }
      ensure
        Thread.critical = old_critical
      end

      begin
        send(method_name, *args)
      ensure
        InstanceExecMethods.module_eval { remove_method(method_name) } rescue nil
      end
    end
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
