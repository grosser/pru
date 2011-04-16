require File.expand_path('spec/spec_helper')

describe Pru do
  before :all do
    @default = `ls -l | wc -l`
  end

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
    `ls -l | ./bin/pru 'i'`.split("\n")[0...3].should == ["1","2","3"]
  end

  it "maps" do
    `echo abc | ./bin/pru 'gsub(/a/,"b")'`.should == "bbc\n"
  end

  it "selects and reduces" do
    `ls -l | ./bin/pru 'include?("G")' 'size'`.should == "2\n"
  end

  it "selects with empty string and reduces" do
    `ls -l | ./bin/pru '' 'size'`.should == @default
  end

  it "reduces" do
    `ls -l | ./bin/pru -r 'size'`.should == @default
  end

  it "can sum" do
    `echo 5 | ./bin/pru -r 'sum(&:to_i)'`.should == "5\n"
  end

  it "can mean" do
    `echo 5 | ./bin/pru -r 'mean(&:to_i)'`.should == "5.0\n"
  end
end
