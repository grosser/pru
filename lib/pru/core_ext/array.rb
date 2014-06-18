class Array
  # http://madeofcode.com/posts/74-ruby-core-extension-array-sum
  def sum(method = nil, &block)
    if block_given?
      raise ArgumentError, "You cannot pass a block and a method!" if method
      inject(0) { |sum, i| sum + yield(i) }
    elsif method
      inject(0) { |sum, i| sum + i.send(method) }
    else
      inject(0) { |sum, i| sum + i }
    end
  end unless method_defined?(:sum)

  def mean(method = nil, &block)
    sum(method, &block) / size.to_f
  end unless method_defined?(:mean)

  def grouped
    group_by { |x| x }
  end unless method_defined?(:grouped)

  def counted
    grouped.sort_by{|d, f| -1 * f.size }.map{|d, f| "#{d} : #{f.size}" }
  end unless method_defined?(:counted)

  def group_by
    hash = {}
    each { |x| hash[yield(x)] = x }
    hash
  end unless method_defined?(:group_by)
end
