require 'net/ip/route'

describe Net::IP::Route do
  it "should be creatable" do
    Net::IP::Route.new.should be_kind_of(Net::IP::Route)
  end
end
