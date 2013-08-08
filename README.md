# Net::IP

Tools for working with IP routes

## Usage

````ruby
require 'net/ip'

Net::IP::Route.flush(:cache)

Net::IP::Route.each do |rt|
  p rt
end

Net::IP::Route.find_gateways("eth0").each do |gw|
  puts gw.via
end

gws = ["192.168.0.1", "192.168.0.2"].collect do |ip|
  Net::IP::Route.new(:via => ip, :dev => "eth0", :weight => 1)
end

Net::IP::Route.update_gateways(gws)
````
