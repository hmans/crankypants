require "./spec_helper"

class HtmlRouter < Crappy::Router
  def call
    get "page" { render html: "<p>Hi!</p>" }
  end
end

describe "render html: ..." do
  r = Crappy::TestRequest(HtmlRouter)

  it "renders the given HTML" do
    r.get("/page").response.body.should eq("<p>Hi!</p>")
  end

  it "sets the correct content type" do
    r.get("/page").response.content_type.should eq("text/html")
  end
end
