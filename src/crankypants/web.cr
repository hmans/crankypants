require "kemal"
require "kilt/slang"

macro render_page(filename)
  render "src/views/#{{{filename}}}.slang", "src/views/layout.slang"
end

get "/" do
  posts = Crankypants::Repo.all(Crankypants::Post)
  render_page "index"
end

get "/crankypants.css" do |env|
  env.response.content_type = "text/css"
  render "src/views/crankypants.css.ecr"
end

get "/posts/:id" do |env|
  id = env.params.url["id"]
  post = Crankypants::Repo.get!(Crankypants::Post, id)
  render_page "post"
end

module Crankypants
  module Web
    extend self

    def run
      Kemal.run
    end
  end
end
