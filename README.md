# Net::IP

Tools for working with IP routes

## Installation

Add this line to your application's Gemfile:

    gem 'net-ip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install net-ip

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
