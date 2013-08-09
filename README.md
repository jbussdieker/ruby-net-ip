# Net::IP

[![Build Status](https://travis-ci.org/jbussdieker/ruby-net-ip.png?branch=master)](https://travis-ci.org/jbussdieker/ruby-net-ip)
[![Code Climate](https://codeclimate.com/github/jbussdieker/ruby-net-ip.png)](https://codeclimate.com/github/jbussdieker/ruby-net-ip)
[![Gem Version](https://badge.fury.io/rb/net-ip.png)](http://badge.fury.io/rb/net-ip)

Tools for working with IP routes and rules

## Usage

### Routes

````ruby
require 'net/ip'

Net::IP.routes.flush(:cache)

Net::IP.routes.each do |route|
  puts route
end

Net::IP.routes.find_gateways.each do |gateway|
  puts gateway.via
end

gws = ["192.168.0.1", "192.168.0.2"].collect do |ip|
  Net::IP::Route.new(:via => ip, :dev => "eth0", :weight => 1)
end

Net::IP.routes.update_gateways(gws)
````

### Rules

````ruby
require 'net/ip'

Net::IP.rules.each do |rule|
  puts rule
end

rule = Net::IP::Rule.new(:to => '1.1.1.1', :table => 'custom')
Net::IP.rules.add(rule)
````
