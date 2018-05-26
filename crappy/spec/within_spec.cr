require "./spec_helper"

class WithinRouter < Crappy::Router
  def call
    within "foo" do
      get { render text: "Getting foo!" }
      post { render text: "Updating foo!"}
    end
  end
end

describe "within" do
  r = Crappy::TestRequest(WithinRouter)

  it "routes requests matching the specified path" do
    r.get("/foo").response.body.should eq("Getting foo!")
    r.post("/foo").response.body.should eq("Updating foo!")
  end

  it "doesn't serve any other paths" do
    r.get("/invalid").response.status_code.should eq(404)
  end
end
