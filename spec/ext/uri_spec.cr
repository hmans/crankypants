require "spec"
require "../../src/ext/uri"

describe "URI Extensions" do
  describe "URI.join" do
    it "replaces the path part if only a path is given" do
      URI.join("http://foo.com/foo", "/bar").to_s.should eq("http://foo.com/bar")
    end

    it "replaces the full URI if the second URI is fully qualified" do
      URI.join("http://foo.com/foo", "http://bar.com/bar").to_s.should eq("http://bar.com/bar")
    end
  end
end
