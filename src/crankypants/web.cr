require "kemal"
require "kilt/slang"

macro render_page(filename)
  render "src/views/#{{{filename}}}.slang", "src/views/layouts/application.slang"
end

get "/" do
  posts = Crankypants::Repo.all(Crankypants::Post)
  render_page "posts/index"
end

get "/crankypants.js" do |env|
  env.response.content_type = "application/javascript"
  render "dist/bundle.js.ecr"
end

# get "/crankypants.css" do |env|
#   env.response.content_type = "text/css"
#   render "src/views/crankypants.css.ecr"
# end

get "/posts/:id" do |env|
  id = env.params.url["id"]
  post = Crankypants::Repo.get!(Crankypants::Post, id)
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
