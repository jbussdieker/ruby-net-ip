module Net
  module IP
    # Class for working with routing table entries.
    class Route
      attr_reader :prefix, :via

      # Create a new route object
      # @example Create a default route
      #  Net::IP::Route.new(:prefix => 'default', :via => '192.168.0.1')
      # @example Create a normal route
      #  Net::IP::Route.new(:prefix => '10.0.0.0/8', :dev => 'eth0')
      # @note This does NOT add the entry to the routing table. See {Route::Collection#add} for creating new routes in the routing table.
      # @param params {Hash}
      def initialize(params = {})
        params.each do |k,v|
          instance_variable_set("@#{k}", v)
        end
      end

      def to_h
        h = {}
        h[:prefix] = @prefix if @prefix
        h[:via] = @via if @via
        h[:dev] = @dev if @dev
        h[:weight] = @weight if @weight
        h[:proto] = @proto if @proto
        h[:scope] = @scope if @scope
        h[:src] = @src if @src
        h[:metric] = @metric if @metric
        h[:error] = @error if @error
        h
      end

      def to_params
        str = ""
        str << "via #{@via} " if @via
        str << "dev #{@dev} " if @dev
        str << "weight #{@weight}" if @weight
        str << " proto #{@proto} " if @proto
        str << " scope #{@scope} " if @scope
        str << " src #{@src} " if @src
        str << " metric #{@metric} " if @metric
        str << " error #{@error}" if @error
        str
      end
    end
  end
end
