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

get "/" do
  posts = Repo.all(Post, Query.order_by("created_at DESC"))
  render_page "posts/index"
end

get "/crankypants.js" do |env|
  env.response.headers.add "Cache-Control", "max-age=600, public"
  env.response.content_type = "text/javascript"
  render "dist/bundle.js.ecr"
end

# get "/crankypants.css" do |env|
#   env.response.content_type = "text/css"
#   render "src/views/crankypants.css.ecr"
# end

post "/posts" do |env|
  post = Post.new
  post.title = env.params.body["post[title]"].as(String)
  post.body =  env.params.body["post[body]"].as(String)

  _changeset = Repo.insert(post)

  env.redirect "/"
end

get "/posts/:id" do |env|
  post = Repo.get!(Post, env.params.url["id"])
  render_page "posts/show"
end

module Crankypants
  module Web
    extend self

    def run
      Kemal.run
    end
  end
end
