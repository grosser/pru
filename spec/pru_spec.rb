require File.expand_path('spec/spec_helper')

describe Pru do
  it "has a VERSION" do
    Pru::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

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
    `cat spec/test.txt | ./bin/pru 'include?("abc")' 'size'`.should == "2\n"
  end

  it "selects with empty string and reduces" do
    `cat spec/test.txt | ./bin/pru '' 'size'`.should == "5\n"
  end

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
end
