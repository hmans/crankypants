require "kemal"
require "kilt/slang"

get "/" do
  posts = Crankypants::Repo.all(Crankypants::Post)
  render "src/views/index.slang", "src/views/layout.slang"
end

get "/crankypants.css" do |env|
  env.response.content_type = "text/css"
  render "src/views/crankypants.css.ecr"
end

get "/posts/:id" do |env|
  id = env.params.url["id"]
  post = Crankypants::Repo.get!(Crankypants::Post, id)
  render "src/views/post.slang", "src/views/layout.slang"
end

module Crankypants
  module Web
    extend self

    def run
      Kemal.run
    end
  end
end
