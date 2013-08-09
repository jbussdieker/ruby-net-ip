require 'net/ip/route'

describe Net::IP::Route do
  it "should be creatable" do
    Net::IP::Route.new.should be_kind_of(Net::IP::Route)
  end

  it "should build param string" do
    route = Net::IP::Route.new(:via => "1.1.1.1", :dev => "eth0", :weight => 1)
    route.build_param_string.should eql("via 1.1.1.1 dev eth0 weight 1")
  end
end
