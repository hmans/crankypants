require "kemal"

db = Crankypants::Database.open
Crankypants::Database.setup(db)

get "/" do
  "Blog LOL!"
end

get "/posts/:key" do |env|
  key = env.params.url["key"]
  post = Crankypants::Post.load_from_database(db, key)
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
