require "./spec_helper"

class TextRouter < Crappy::Router
  def call
    get "text" { render text: "Hello world" }
  end
end

describe "render text: ..." do
  r = Crappy::TestRequest(TextRouter)

  it "renders the given text" do
    r.get("/text").response.body.should eq("Hello world")
  end

  it "sets the correct content type" do
    r.get("/text").response.content_type.should eq("text/plain")
  end
end
