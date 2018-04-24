require "kemal"
require "./helpers"

module Crankypants::Web::Blog
  include Helpers

  def self.mount
    # Our root page renders this site's latest posts.
    #
    get "/" do
      posts = Data.load_posts
      PostView.index posts: posts
    end

    # This is where we render individual posts.
    #
    get "/posts/:id" do |env|
      post = Data.load_post(env.params.url["id"].to_i)
      PostView.show post: post
    end

    # Here's our statically linked-ish bundle for the blog...
    #
    {% if flag?(:release) %}
      get "/blog-bundle.js" do |env|
        env.response.headers.add "Cache-Control", "max-age=600, public"
        env.response.content_type = "text/javascript"
        serve_static_asset "blog-bundle.js"
      end

      get "/blog.css" do |env|
        env.response.headers.add "Cache-Control", "max-age=600, public"
        env.response.content_type = "text/css"
        serve_static_asset "blog.css"
      end
    {% end %}
  end
end
