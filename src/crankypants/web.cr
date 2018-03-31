require "kemal"

get "/" do
  posts = Crankypants::Repo.all(Crankypants::Post)

  render "src/views/index.ecr"
end

get "/posts/:id" do |env|
  id = env.params.url["id"]
  post = Crankypants::Repo.get!(Crankypants::Post, id)

  render "src/views/post.ecr"
end

module Crankypants
  module Web
    extend self

    def run
      Kemal.run
    end
  end
end
