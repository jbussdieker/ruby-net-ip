require 'net/ip/rule/parser'

describe Net::IP::Rule::Parser do
  context "line parser" do
    def test_parse_line(line, field, expect)
      h = Net::IP::Rule::Parser.parse_line(line)
      h[field].should eql(expect)
    end

    it "should parse priority" do
      test_parse_line("0:	from all lookup local ", :priority, "0")
    end

    it "should parse from" do
      test_parse_line("0:	from all lookup local ", :from, "all")
    end

    it "should parse lookup" do
      test_parse_line("0:	from all lookup local ", :lookup, "local")
    end

    it "should parse to" do
      test_parse_line("32756:	from all to 1.2.3.1 lookup custom ", :to, "1.2.3.1")
    end
  end

  context "parser" do
    def test_parse(file, expect)
      Net::IP::Rule::Parser.parse(File.read(file)).should eql(expect)
    end

    it "handles sample 1" do
      test_parse("spec/net/ip/rule/sample1", [
        {:priority=>"0", :from=>"all", :lookup=>"local"},
        {:priority=>"32766", :from=>"all", :lookup=>"main"},
        {:priority=>"32767", :from=>"all", :lookup=>"default"}
      ])
    end

    it "handles sample 2" do
      test_parse("spec/net/ip/rule/sample2", [
        {:priority=>"0", :from=>"all", :lookup=>"local"},
        {:priority=>"32756", :from=>"all", :to=>"1.2.3.1", :lookup=>"custom"},
        {:priority=>"32757", :from=>"all", :to=>"1.2.3.2", :lookup=>"custom"},
        {:priority=>"32758", :from=>"all", :to=>"1.2.3.3", :lookup=>"custom"},
        {:priority=>"32759", :from=>"all", :to=>"1.2.3.4", :lookup=>"custom"},
        {:priority=>"32760", :from=>"all", :to=>"1.2.3.5", :lookup=>"custom"},
        {:priority=>"32761", :from=>"all", :to=>"1.2.3.6", :lookup=>"custom"},
        {:priority=>"32762", :from=>"all", :to=>"1.2.3.7", :lookup=>"custom"},
        {:priority=>"32763", :from=>"all", :to=>"1.2.3.8", :lookup=>"custom"},
        {:priority=>"32764", :from=>"all", :to=>"1.2.3.9", :lookup=>"custom"},
        {:priority=>"32765", :from=>"all", :to=>"1.2.3.10", :lookup=>"custom"},
        {:priority=>"32766", :from=>"all", :lookup=>"main"},
        {:priority=>"32767", :from=>"all", :lookup=>"default"}
      ])
    end
  end
end
