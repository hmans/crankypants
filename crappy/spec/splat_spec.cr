require "./spec_helper"

class SplatRouter < Crappy::Router
  def call
    within "foo" do
      splat do |s|
        get { render text: "Splat: #{s}" }
      end
    end
  end
end

describe "splat" do
  r = Crappy::TestRequest(SplatRouter)

  it "gobbles up the remaining path" do
    r.get("/foo/bar/baz").response.body
      .should eq("Splat: [\"bar\", \"baz\"]")
  end
end
