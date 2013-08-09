module Net
  module IP
    # Class for working with routing table entries.
    class Route
      attr_accessor :type, :prefix, :dev, :scope, :metric, 
                    :proto, :src, :via, :weight, :table, :error

      extend Enumerable

      # Create a new route object
      # @example Create a default route
      #  Net::IP::Route.new(:prefix => 'default', :via => '192.168.0.1')
      # @example Create a normal route
      #  Net::IP::Route.new(:prefix => '10.0.0.0/8', :dev => 'eth0')
      # @note This does NOT add the entry to the routing table. See {add_route} for creating new routes in the routing table.
      # @param params {Hash}
      def initialize(params = {})
        params.each do |k,v|
          send("#{k}=", v)
        end
      end

      # Enumerate all routes
      # @yield {Route}
      # @return {void}
      def self.each(&block)
        RouteParser.parse(`ip route`).each {|r| yield(new(r))}
      end

      # Get a list of all routes
      # @return {Array<Route>}
      def self.all
        RouteParser.parse(`ip route`).collect {|r| new(r)}
      end

      # Get a list of all default gateway routes
      # @return {Array<Route>}
      def self.find_gateways
        find_all {|r| r.prefix == "default"}
      end

      # Update the list of default gateways
      # @example Change the default gateway to 192.168.0.1
      #  gateway = Net::IP::Route.new(:prefix => 'default', :via => '192.168.0.1')
      #  Net::IP::Route.update_gateways([gateway])
      # @param gateways {Array<Route>} List of default gateways to use.
      # @return {void}
      def self.update_gateways(gateways)
        params = gateways.collect {|gateway| "nexthop " + gateway.build_param_string}
        result = `ip route replace default #{params.join(" ")}`
        raise result unless $?.success?
      end

      # Add a route to the routing table
      # @example Create a route to the 10.0.0.0/8 network
      #  route = Net::IP::Route.new(:prefix => '10.0.0.0/8', :dev => 'eth0')
      #  Net::IP::Route.add_route(route)
      # @param route {Route} Route to add to the table.
      # @return {void}
      def self.add_route(route)
        result = `ip route add #{route.build_param_string}`
        raise result unless $?.success?
      end

      # Flush the routing table based on a selector
      # @example Flush the routing table cache
      #  Net::IP::Route.flush(:cache)
      # @param selector {String} The selector string.
      # @return {void}
      def self.flush(selector)
        result = `ip route flush #{selector}`
        raise result unless $?.success?
      end

      def build_param_string
        str = ""
        str << "via #{via} " if via
        str << "dev #{dev} " if dev
        str << "weight #{weight}" if weight
        str << " table #{table} " if table
        str << " proto #{proto} " if proto
        str << " scope #{scope} " if scope
        str << " src #{src} " if src
        str << " metric #{metric} " if metric
        str << " error #{error}" if error
        str
      end
    end
  end
end
