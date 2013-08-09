require "net/ip/route"

module Net
  module IP
    class Route
      # Parses routing table entries
      class Parser
        # Parse a routing table entry into a hash
        #
        # @param line {String}
        # @return {Hash}
        def self.parse_line(line)
          params = {}

          if line =~ /^(unicast|unreachable|blackhole|prohibit|local|broadcast|throw|nat|via|anycast|multicast)\s+/
            params[:type] = $1
            line = line[$1.length..-1]
          end

          params[:prefix] = line.split.first
          params[:dev] = $1 if line =~ /\s+dev\s+([^\s]+)/
          params[:scope] = $1 if line =~ /\s+scope\s+([^\s]+)/
          params[:metric] = $1 if line =~ /\s+metric\s+([^\s]+)/
          params[:proto] = $1 if line =~ /\s+proto\s+([^\s]+)/
          params[:src] = $1 if line =~ /\s+src\s+([^\s]+)/
          params[:via] = $1 if line =~ /\s+via\s+([^\s]+)/
          params[:weight] = $1 if line =~ /\s+weight\s+([^\s]+)/
          params[:table] = $1 if line =~ /\s+table\s+([^\s]+)/
          params[:error] = $1 if line =~ /\s+error\s+([^\s]+)/

          params
        end

        # Parse the output of ip route into an array of hashes
        #
        # @param data {String}
        # @return {Array}
        def self.parse(data)
          list = []
          in_default = false
          data.each_line do |line|
            if in_default == true
              if line.start_with? "\t"
                list << parse_line(line.strip.gsub("nexthop", "default"))
              else
                in_default = false
              end
            elsif line.strip == "default"
              in_default = true
            end

            unless in_default
              list << parse_line(line.strip)
            end
          end
          list
        end
      end
    end
  end
end
