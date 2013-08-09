module Net
  module IP
    class Rule
      class Parser
        # Parse a rule entry into a hash
        #
        # @param line {String}
        # @return {Hash}
        def self.parse_line(line)
          params = {}
          params[:priority] = $1 if line =~ /^(\d+):\t/
          params[:from] = $1 if line =~ /\s+from\s+([^\s]+)\s+/
          params[:to] = $1 if line =~ /\s+to\s+([^\s]+)\s+/
          params[:lookup] = $1 if line =~ /\s+lookup\s+([^\s]+)\s+/
          params[:realms] = $1 if line =~ /\s+realms\s+([^\s]+)\s+/
          params[:map_to] = $1 if line =~ /\s+map-to\s+([^\s]+)\s+/
          params
        end

        def self.parse(data)
          list = []
          data.split("\n").each do |line|
            list << parse_line(line)
          end
          list
        end
      end
    end
  end
end
