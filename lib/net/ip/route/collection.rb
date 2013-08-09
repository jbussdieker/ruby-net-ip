require "net/ip/route"
require "net/ip/route/parser"

module Net
  module IP
    class Route
      class Collection
        include Enumerable

        def initialize(table = "main")
          @table = table
        end

        # Enumerate all routes
        # @yield {Route}
        # @return {void}
        def each(&block)
          Parser.parse(`ip route show table #{@table}`).each {|r| yield(Route.new(r))}
        end

        # Get a list of all routes
        # @return {Array<Route>}
        def all
          Parser.parse(`ip route show table #{@table}`).collect {|r| Route.new(r)}
        end

        # Get a list of all default gateway routes
        # @return {Array<Route>}
        def gateways
          find_all {|r| r.prefix == "default"}
        end

        # Update the list of default gateways
        # @example Change the default gateway to 192.168.0.1
        #  gateway = Net::IP::Route.new(:prefix => 'default', :via => '192.168.0.1')
        #  Net::IP::Route.update_gateways([gateway])
        # @param gateways {Array<Route>} List of default gateways to use.
        # @return {void}
        def update_gateways(gateways)
          params = gateways.collect {|gateway| "nexthop " + gateway.to_params}
          result = `ip route replace default #{params.join(" ")}`
          raise result unless $?.success?
        end

        # Add a route to the routing table
        # @example Create a route to the 10.0.0.0/8 network
        #  route = Net::IP::Route.new(:prefix => '10.0.0.0/8', :dev => 'eth0')
        #  Net::IP::Route.add_route(route)
        # @param route {Route} Route to add to the table.
        # @return {void}
        def add(route)
          result = `ip route add #{route.to_params}`
          raise result unless $?.success?
        end

        # Flush the routing table based on a selector
        # @example Flush the routing table cache
        #  Net::IP::Route.flush(:cache)
        # @param selector {String} The selector string.
        # @return {void}
        def flush(selector)
          result = `ip route flush #{selector}`
          raise result unless $?.success?
        end
      end
    end
  end
end
