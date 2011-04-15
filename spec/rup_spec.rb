require File.expand_path('spec/spec_helper')

describe Rup do
  it "has a VERSION" do
    Rup::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it "maps" do
    `ls -l | ./bin/rup 'include?("G")'`.split("\n").size.should == 2
  end

  it "maps and reduces" do
    `ls -l | ./bin/rup 'include?("G")' 'size'`.should == "2\n"
  end

  it "maps with empty string and reduces" do
    `ls -l | ./bin/rup '' 'size'`.should == "10\n"
  end

  it "reduces" do
    `ls -l | ./bin/rup -r 'size'`.should == "10\n"
  end
end
