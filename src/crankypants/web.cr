require "kemal"

get "/" do
  "Blog LOL!"
end

get "/posts/:key" do |env|
  key = env.params.url["key"]
  post = Crankypants::Repo.get!(Crankypants::Post, 1)
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
