require 'pru/core_ext/array'
require 'pru/core_ext/symbol'

module Pru
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  def self.map(io, code)
    String.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def _pru(i)
        #{code}
      end
    RUBY

    io.each_line.with_index do |line, i|
      line.chomp!
      result = line._pru(i+1) or next

      case result
      when true then yield line
      when Regexp then yield line if line =~ result
      else yield result
      end
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
