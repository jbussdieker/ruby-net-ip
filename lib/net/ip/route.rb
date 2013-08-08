module Net
  module IP
    class Route
      attr_accessor :type, :prefix, :dev, :scope, :metric, 
                    :proto, :src, :via, :weight, :table, :error

      extend Enumerable

      def to_s
        str = ""
        str << type << " " if type != "unicast"
        str << prefix << " "

        str << "via #{via} " if via

        str << "dev #{dev} " if dev

        str << " table #{table} " if table
        str << " proto #{proto} " if proto
        str << " scope #{scope} " if scope

        str << " src #{src} " if src
        str << " metric #{metric} " if metric

        str << " error #{error}" if error

        str
      end

      def self.each(&block)
        parse(`ip route`).each {|r| yield(r)}
      end

      def self.all
        parse(`ip route`)
      end

      def self.find_gateways(dev = nil)
        if dev
          find_all {|r| r.prefix == "default" and r.dev == dev}
        else
          find_all {|r| r.prefix == "default"}
        end
      end

private

      def self.parse_line(line)
        route = new

        if line =~ /^(unicast|unreachable|blackhole|prohibit|local|broadcast|throw|nat|via|anycast|multicast)\s+/
          route.type = $1
          line = line[$1.length..-1]
        else
          route.type = "unicast"
        end

        route.prefix = line.split.first
        route.dev = $1 if line =~ /\s+dev\s+([^\s]+)/
        route.scope = $1 if line =~ /\s+scope\s+([^\s]+)/
        route.metric = $1 if line =~ /\s+metric\s+([^\s]+)/
        route.proto = $1 if line =~ /\s+proto\s+([^\s]+)/
        route.src = $1 if line =~ /\s+src\s+([^\s]+)/
        route.via = $1 if line =~ /\s+via\s+([^\s]+)/
        route.weight = $1 if line =~ /\s+weight\s+([^\s]+)/
        route.table = $1 if line =~ /\s+table\s+([^\s]+)/
        route.error = $1 if line =~ /\s+error\s+([^\s]+)/

        route
      end

      def self.parse_data(data, &block)
        in_default = false
        data.each_line do |line|
          if in_default == true
            if line.start_with? "\t"
              yield(parse_line(line.strip.gsub("nexthop", "default")))
            else
              in_default = false
            end
          elsif line.strip == "default"
            in_default = true
          end

          unless in_default
            yield(parse_line(line.strip))
          end
        end
      end

      def self.parse(data)
        list = []
        parse_data(data) do |route|
          list << route
        end
        list
      end
    end
  end
end
