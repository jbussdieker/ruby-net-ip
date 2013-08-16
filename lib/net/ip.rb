require "net/ip/version"
require "net/ip/route/collection"
require "net/ip/rule/collection"

module Net
  module IP
    # Get list of routes
    # @param table {String} The name of the routing table
    # @return {Route::Collection}
    def self.routes(table = "main")
      Route::Collection.new(table)
    end

    # Get list of rules
    # @return {Rule::Collection}
    def self.rules
      Rule::Collection.new
    end
  end
end
