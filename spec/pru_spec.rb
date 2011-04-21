require File.expand_path('spec/spec_helper')

describe Pru do
  it "has a VERSION" do
    Pru::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  describe 'map' do
    it "selects" do
      `ls -l | ./bin/pru 'include?("G")'`.split("\n").size.should == 2
    end

    it "can selects via regex" do
      `ls -l | ./bin/pru /G/`.split("\n").size.should == 2
    end

    it "can selects via i" do
      `cat spec/test.txt | ./bin/pru 'i'`.split("\n")[0...3].should == ["1","2","3"]
    end

    it "maps" do
      `echo abc | ./bin/pru 'gsub(/a/,"b")'`.should == "bbc\n"
    end

    it "selects and reduces" do
      `cat spec/test.txt | ./bin/pru 'include?("abc")' 'size'`.should == "3\n"
    end

    it "can open files" do
      `echo spec/test.txt | ./bin/pru 'File.read(self)'`.should == File.read('spec/test.txt')
    end

    it "can open preserves whitespaces" do
      `echo ' ab\tcd ' | ./bin/pru 'self'`.should == " ab\tcd \n"
    end
  end

  describe 'reduce' do
    it "reduces" do
      `cat spec/test.txt | ./bin/pru -r 'size'`.should == "5\n"
    end

    it "prints arrays as newlines" do
      `cat spec/test.txt | ./bin/pru -r 'self'`.should == File.read('spec/test.txt')
    end

    it "can sum" do
      `cat spec/test.txt | ./bin/pru -r 'sum(&:to_i)'`.should == "1212\n"
    end

    it "can mean" do
      `cat spec/test.txt | ./bin/pru -r 'mean(&:to_i)'`.should == "242.4\n"
    end

    it "can grouped" do
      `cat spec/test.txt | ./bin/pru -r 'grouped.map{|a,b| b.size }'`.should include("2\n")
    end
  end

  describe 'map and reduce' do
    it "selects with empty string and reduces" do
      `cat spec/test.txt | ./bin/pru '' 'size'`.should == "5\n"
    end
  end
end
