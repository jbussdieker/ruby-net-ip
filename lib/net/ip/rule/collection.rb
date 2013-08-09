require "net/ip/rule"
require "net/ip/rule/parser"

module Net
  module IP
    class Rule
      class Collection
        include Enumerable

        # Enumerate all rules
        # @yield {Rule}
        # @return {void}
        def each(&block)
          Parser.parse(`ip rule list`).each {|r| yield(Rule.new(r))}
        end

        # Add a rule to the ip rule list
        # @example Create a rule for 1.2.3.4 to use routing table 'custom'
        #  rule = Net::IP::Rule.new(:to => '1.2.3.4', :table => 'custom')
        #  Net::IP.rules.add_rule(rule)
        # @param rule {Rule} Rule to add to the list.
        # @return {void}
        def add(rule)
          result = `ip rule add #{rule.to_params}`
          raise result unless $?.success?
        end

        # Delete a rule from the ip rule list
        # @example Delete a rule for 1.2.3.4 using routing table 'custom'
        #  rule = Net::IP::Rule.new(:to => '1.2.3.4', :table => 'custom')
        #  Net::IP.rules.delete_rule(rule)
        # @param rule {Rule} Rule to delete from the list.
        # @return {void}
        def delete(rule)
          result = `ip rule delete #{rule.to_params}`
          raise result unless $?.success?
        end
      end
    end
  end
end
