require "net/ip/version"
require "net/ip/route/collection"
require "net/ip/rule/collection"

module Net
  module IP
    # Get list of routes
    # @return {Route::Collection}
    def self.routes
      Route::Collection.new
    end

    # Get list of rules
    # @return {Rule::Collection}
    def self.rules
      Rule::Collection.new
    end
  end
end
