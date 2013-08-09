module Net
  module IP
    # Class for working with ip rules.
    class Rule
      # Create a new rule object
      # @example Create a rule to use a different route table
      #  Net::IP::Rule.new(:to => '1.2.3.4', :table => 'custom')
      # @note This does NOT add the entry to the ip rules. See {Rule::Collection#add} for creating new rules in the ip rule list.
      # @param params {Hash}
      def initialize(params = {})
        params.each do |k,v|
          instance_variable_set("@#{k}", v)
        end
      end

      def to_params
        str = ""
        str << "priority #{@priority} " if @priority
        str
      end
    end
  end
end
