# Net::IP

[![Build Status](https://travis-ci.org/jbussdieker/ruby-net-ip.png?branch=master)](https://travis-ci.org/jbussdieker/ruby-net-ip)
[![Code Climate](https://codeclimate.com/github/jbussdieker/ruby-net-ip.png)](https://codeclimate.com/github/jbussdieker/ruby-net-ip)
[![Gem Version](https://badge.fury.io/rb/net-ip.png)](http://badge.fury.io/rb/net-ip)

Tools for working with IP routes

## Usage

````ruby
require 'net/ip'

Net::IP::Route.flush(:cache)

Net::IP::Route.each do |route|
  puts route
end

Net::IP::Route.find_gateways.each do |gateway|
  puts gateway.via
end

gws = ["192.168.0.1", "192.168.0.2"].collect do |ip|
  Net::IP::Route.new(:via => ip, :dev => "eth0", :weight => 1)
end

Net::IP::Route.update_gateways(gws)
````
