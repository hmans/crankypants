require "./spec_helper"

class WithinArrayRouter < Crappy::Router
  def call
    within ["foo", "bar"] do
      get  { render text: "Getting foo or bar!" }
    end

    get ["one", "two"] { render text: "I like numbers!" }

    within "posts" do
      get [":id-:slug", :id] do |params|
        render text: "ID: #{params["id"]?}\nSlug: #{params["slug"]?}"
      end
    end
  end
end

describe "within(Array)" do
  r = Crappy::TestRequest(WithinArrayRouter)

  it "works with within" do
    r.get("/foo").response.body.should eq("Getting foo or bar!")
    r.get("/bar").response.body.should eq("Getting foo or bar!")
  end

  it "works with request matchers" do
    r.get("/one").response.body.should eq("I like numbers!")
    r.get("/two").response.body.should eq("I like numbers!")
  end

  it "works with dynamic parts" do
    r.get("/posts/123").response.body.should eq("ID: 123\nSlug: ")
    r.get("/posts/123-foo").response.body.should eq("ID: 123\nSlug: foo")
  end

  it "doesn't serve any other paths" do
    r.get("/invalid").response.status_code.should eq(404)
  end
end
