require 'net/ip/route_parser'

describe Net::IP::RouteParser do
  context "line parser" do
    def test_parse_line(line, field, expect)
      h = Net::IP::RouteParser.parse_line(line)
      h[field].should eql(expect)
    end

    it "should parse prefix" do
      test_parse_line("1.1.0.0/16 dev eth0  scope link  metric 1000", :prefix, "1.1.0.0/16")
    end

    it "should parse dev" do
      test_parse_line("1.1.0.0/16 dev eth0  scope link  metric 1000", :dev, "eth0")
    end

    it "should parse scope" do
      test_parse_line("1.1.0.0/16 dev eth0  scope link  metric 1000", :scope, "link")
    end

    it "should parse metric" do
      test_parse_line("1.1.0.0/16 dev eth0  scope link  metric 1000", :metric, "1000")
    end

    it "should parse proto" do
      test_parse_line("1.0.0.0/24 dev eth0  proto kernel  scope link  src 1.0.1.1", :proto, "kernel")
    end

    it "should parse src" do
      test_parse_line("1.0.0.0/24 dev eth0  proto kernel  scope link  src 1.0.1.1", :src, "1.0.1.1")
    end

    it "should parse type" do
      test_parse_line("unreachable default dev lo  table unspec  proto kernel  metric -1  error -101", :type, "unreachable")
    end

    it "should parse table" do
      test_parse_line("unreachable default dev lo  table unspec  proto kernel  metric -1  error -101", :table, "unspec")
    end

    it "should parse error" do
      test_parse_line("unreachable default dev lo  table unspec  proto kernel  metric -1  error -101", :error, "-101")
    end
  end

  context "parser" do
    def test_parse(file, expect)
      Net::IP::RouteParser.parse(File.read(file)).should eql(expect)
    end

    it "handles sample 1" do
      test_parse("spec/net/ip/sample1", [
        {:prefix=>"default", :dev=>"eth0", :proto=>"static", :via=>"192.168.0.1"},
        {:prefix=>"169.254.0.0/16", :dev=>"eth0", :scope=>"link", :metric=>"1000"},
        {:prefix=>"192.168.0.0/24", :dev=>"eth0", :scope=>"link", :metric=>"1", :proto=>"kernel", :src=>"192.168.0.15"}
      ])
    end

    it "handles sample 2" do
      test_parse("spec/net/ip/sample2", [
        {:prefix=>"default", :dev=>"eth0", :via=>"10.0.61.225", :weight=>"1"},
        {:prefix=>"default", :dev=>"eth0", :via=>"10.0.45.153", :weight=>"1"},
        {:prefix=>"10.0.0.0", :dev=>"eth0", :via=>"10.0.0.1"},
        {:prefix=>"10.0.0.0/18", :dev=>"eth0", :scope=>"link", :proto=>"kernel", :src=>"10.0.14.184"},
        {:prefix=>"169.254.169.254", :dev=>"eth0", :via=>"10.0.0.1"}
      ])
    end

    it "handles sample 3" do
      test_parse("spec/net/ip/sample3", [
        {:prefix=>"default", :dev=>"eth0", :via=>"10.0.35.196"},
        {:prefix=>"10.0.0.0", :dev=>"eth0", :via=>"10.0.0.1"},
        {:prefix=>"10.0.0.0/18", :dev=>"eth0", :scope=>"link", :proto=>"kernel", :src=>"10.0.58.155"},
        {:prefix=>"169.254.169.254", :dev=>"eth0", :via=>"10.0.0.1"}
      ])
    end

    it "handles sample 4" do
      test_parse("spec/net/ip/sample4", [
        {:prefix=>"default", :dev=>"eth0", :via=>"192.168.0.1"},
        {:prefix=>"169.254.0.0/16", :dev=>"eth0", :scope=>"link", :metric=>"1000"},
        {:prefix=>"192.168.0.0/24", :dev=>"eth0", :scope=>"link", :metric=>"1", :proto=>"kernel", :src=>"192.168.0.15"},
        {:type=>"broadcast", :prefix=>"127.0.0.0", :dev=>"lo", :scope=>"link", :proto=>"kernel", :src=>"127.0.0.1", :table=>"local"},
        {:type=>"local", :prefix=>"127.0.0.0/8", :dev=>"lo", :scope=>"host", :proto=>"kernel", :src=>"127.0.0.1", :table=>"local"},
        {:type=>"local", :prefix=>"127.0.0.1", :dev=>"lo", :scope=>"host", :proto=>"kernel", :src=>"127.0.0.1", :table=>"local"},
        {:type=>"broadcast", :prefix=>"127.255.255.255", :dev=>"lo", :scope=>"link", :proto=>"kernel", :src=>"127.0.0.1", :table=>"local"},
        {:type=>"broadcast", :prefix=>"192.168.0.0", :dev=>"eth0", :scope=>"link", :proto=>"kernel", :src=>"192.168.0.15", :table=>"local"},
        {:type=>"local", :prefix=>"192.168.0.15", :dev=>"eth0", :scope=>"host", :proto=>"kernel", :src=>"192.168.0.15", :table=>"local"},
        {:type=>"broadcast", :prefix=>"192.168.0.255", :dev=>"eth0", :scope=>"link", :proto=>"kernel", :src=>"192.168.0.15", :table=>"local"},
        {:prefix=>"fe80::/64", :dev=>"eth0", :metric=>"256", :proto=>"kernel"},
        {:type=>"unreachable", :prefix=>"default", :dev=>"lo", :metric=>"-1", :proto=>"kernel", :table=>"unspec", :error=>"-101"},
        {:type=>"local", :prefix=>"::1", :dev=>"lo", :metric=>"0", :proto=>"none", :via=>"::", :table=>"local"},
        {:type=>"local", :prefix=>"fe80::226:18ff:fe3a:3112", :dev=>"lo", :metric=>"0", :proto=>"none", :via=>"::", :table=>"local"},
        {:prefix=>"ff00::/8", :dev=>"eth0", :metric=>"256", :table=>"local"},
        {:type=>"unreachable", :prefix=>"default", :dev=>"lo", :metric=>"-1", :proto=>"kernel", :table=>"unspec", :error=>"-101"}
      ])
    end
  end
end
