require "./spec_helper"

class JsonRouter < Crappy::Router
  def call
    get "data" { render json: { foo: "Foo!" } }
  end
end

describe "render json: ..." do
  r = Crappy::TestRequest(JsonRouter)

  it "renders a JSON representation of the given object" do
    r.get("/data").response.body.should eq("{\"foo\":\"Foo!\"}")
  end

  it "sets the correct content type" do
    r.get("/data").response.content_type.should eq("application/json")
  end
end
