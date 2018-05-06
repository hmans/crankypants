require "./spec_helper"

class TestRouter < Crappy::Router
  def call
    # Some static paths
    get "foo" { render text: "Foo!" }
    get "bar" { render text: "Bar!" }

    # A dynamic section
    within "hello" do
      get :name do |params|
        render text: "Hello, #{params["name"]}!"
      end

      get do
        render text: "Please specify a name!"
      end
    end

    # A partially parameterized path
    get "hello-:name" do |params|
      render text: "Hello again, #{params["name"]}!"
    end

    get { render text: "Home!" }
  end
end

describe Crappy::Router do
  r = Crappy::TestRequest(TestRouter)

  it "correctly routes requests to the root path" do
    r.get("/").response.body.should eq("Home!")
  end

  it "correctly routes requests to static paths" do
    r.get("/foo").response.body.should eq("Foo!")
    r.get("/bar").response.body.should eq("Bar!")
  end

  it "correctly routes requests to parameterized paths" do
    r.get("/hello/Hendrik").response.body.should eq("Hello, Hendrik!")
  end

  it "correctly routes requests to the default request blocks of within blocks" do
    r.get("/hello").response.body.should eq("Please specify a name!")
  end

  it "correctly routes requests to partially parameterized paths" do
    r.get("/hello-Hendrik").response.body.should eq("Hello again, Hendrik!")
  end

  it "does nothing when the request can't be matched" do
    r.get("/invalid").response.status_code.should eq(404)
  end
end



class DeepRouter < Crappy::Router
  def call
    get "foo/foo" { render text: "foofoo" }
    get "foo/bar" { render text: "foobar" }
    get "posts/:id" { |params| render text: "Post #{params["id"]}" }
    get "posts/:id/:slug" { |params| render text: "Post #{params["id"]} with Slug #{params["slug"]}" }
  end
end

describe "deep routing" do
  r = Crappy::TestRequest(DeepRouter)

  it "works with static parts" do
    r.get("foo/foo").response.body.should eq("foofoo")
    r.get("foo/bar").response.body.should eq("foobar")
    r.get("foo/invalid").response.status_code.should eq(404)
  end

  it "works with dynamic parts" do
    r.get("posts/123").response.body.should eq("Post 123")
  end

  it "works with dynamic parts on separate parts" do
    r.get("posts/123/foo").response.body.should eq("Post 123 with Slug foo")
  end
end
