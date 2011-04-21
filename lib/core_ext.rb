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
  
  def mean(method = nil, &block)
    sum(method, &block) / size.to_f
  end

  def grouped
    group_by{|x|x}
  end
end
