require "kemal"
require "kilt/slang"
require "crecto"

Query = Crecto::Repo::Query
Multi = Crecto::Multi
Repo  = Crankypants::Repo
Post  = Crankypants::Post

macro render_page(filename)
  render "src/views/#{{{filename}}}.slang", "src/views/layouts/application.slang"
end

module Crankypants
  module Web
    def self.run
      # Our root page renders this site's latest posts.
      #
      get "/" do
        posts = Repo.all(Post, Query.order_by("created_at DESC"))
        render_page "posts/index"
      end

      # This is where we render individual posts.
      #
      get "/posts/:id" do |env|
        post = Repo.get!(Post, env.params.url["id"])
        render_page "posts/show"
      end

      # We compile our Webpack bundle into this app to serve
      # it directly. Yes, this is sick and twisted, but the goal
      # is to have a single self-contained executable, so there
      # you go.
      #
      get "/crankypants.js" do |env|
        env.response.headers.add "Cache-Control", "max-age=600, public"
        env.response.content_type = "text/javascript"
        render "dist/bundle.js.ecr"
      end

      # POST requests to /posts create a new posts. No idea
      # how long-lived this will be since we eventually want
      # all admin stuff to go through a client-side app
      # that talks to a JSON API.
      #
      post "/posts" do |env|
        post = Post.new
        post.title = env.params.body["post[title]"].as(String)
        post.body =  env.params.body["post[body]"].as(String)

        _changeset = Repo.insert(post)

        env.redirect "/"
      end

      Kemal.run
    end
  end
end
