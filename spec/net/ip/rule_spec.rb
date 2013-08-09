require 'net/ip/rule'

describe Net::IP::Rule do
  it "should be creatable" do
    Net::IP::Rule.new.should be_kind_of(Net::IP::Rule)
  end

  it "should be convert to_params" do
    Net::IP::Rule.new(:priority => '1').to_params.should eql("priority 1 ")
  end
end
