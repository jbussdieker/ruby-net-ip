require 'net/ip/route'

describe Net::IP::Route do
  it "should be creatable" do
    Net::IP::Route.new.should be_kind_of(Net::IP::Route)
  end

  it "should be convert to_params" do
    Net::IP::Route.new(:dev => 'eth0').to_params.should eql("dev eth0 ")
  end
end
