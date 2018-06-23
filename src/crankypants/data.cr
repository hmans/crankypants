require "./repo"
require "./formatter"
require "./models/*"

module Crankypants
  module Data
    Query = Crecto::Repo::Query
    Multi = Crecto::Multi
    Post  = Models::Post


    def self.load_post(id : Int32)
      Repo.get!(Post, id)
    end

    def self.delete_post(id : Int32)
      post = Repo.get!(Post, id)
      Repo.delete(post)
    end

    def self.update_post(post : Models::Post)
      post.body_html = Formatter.new(post.body.as(String)).complete.to_s
      Repo.update(post)
    end
  end
end
