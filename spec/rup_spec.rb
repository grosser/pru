require File.expand_path('spec/spec_helper')

describe Rup do
  it "has a VERSION" do
    Rup::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
