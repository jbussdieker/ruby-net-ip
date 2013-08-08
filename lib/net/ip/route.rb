module Net
  module IP
    class Route
      attr_accessor :type, :prefix, :dev, :scope, :metric, 
                    :proto, :src, :via, :weight, :table, :error

      extend Enumerable

      def initialize(params = {})
        params.each do |k,v|
          send("#{k}=", v)
        end
      end

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

      def self.update_gateways(gws)
        params = gws.collect {|gw| "nexthop via #{gw.via} dev #{gw.dev} weight #{gw.weight}"}.join(" ")
        result = `ip route replace default #{params}`
        raise result unless $?.success?
      end

      def self.flush(selector)
        result = `ip route flush #{selector}`
        raise result unless $?.success?
      end

private

      def self.parse_line(line)
        params = {}

        if line =~ /^(unicast|unreachable|blackhole|prohibit|local|broadcast|throw|nat|via|anycast|multicast)\s+/
          params[:type] = $1
          line = line[$1.length..-1]
        else
          params[:type] = "unicast"
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

        new(params)
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
