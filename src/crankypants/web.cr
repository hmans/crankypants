require "kemal"
require "kilt/slang"
require "crecto"
require "./formatter"
require "./models/*"
require "./blog"

private macro render_page(filename)
  render "src/views/#{{{filename}}}.slang", "src/views/layouts/application.slang"
end

module Crankypants
  module Web
    Post = Models::Post

    def self.run
      # This is our self-contained Vue app that you use for posting,
      # reading your feed, et al. OMG MAGICKS
      get "/app" do
        render "src/views/app.slang"
      end

      # Our root page renders this site's latest posts.
      #
      get "/" do
        posts = Blog.load_posts
        render_page "posts/index"
      end

      # This is where we render individual posts.
      #
      get "/posts/:id" do |env|
        post = Blog.load_post(env.params.url["id"].to_i)
        render_page "posts/show"
      end

      # We compile our Webpack bundle into this app to serve
      # it directly. Yes, this is sick and twisted, but the goal
      # is to have a single self-contained executable, so there
      # you go.
      #
      {% if flag?(:release) %}
        get "/blog-bundle.js" do |env|
          env.response.headers.add "Cache-Control", "max-age=600, public"
          env.response.content_type = "text/javascript"
          render "public/blog-bundle.js.ecr"
        end
      {% end %}

      # POST requests to /posts create a new posts. No idea
      # how long-lived this will be since we eventually want
      # all admin stuff to go through a client-side app
      # that talks to a JSON API.
      #
      post "/posts" do |env|
        post = Post.new
        post.title = env.params.body["post[title]"].as(String)
        post.body = env.params.body["post[body]"].as(String)
        post.body_html = Formatter.new(post.body.as(String)).markdown.to_s

        Blog.create_post(post)

        env.redirect "/"
      end

      Kemal.run
    end
  end
end
