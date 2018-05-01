require "./repo"
require "./formatter"
require "./models/*"

module Crankypants
  module Data
    Query = Crecto::Repo::Query
    Multi = Crecto::Multi
    Post  = Models::Post

    def self.count_posts
      Repo.aggregate(Post, :count, :id).as(Int64)
    end

    def self.load_posts
      Repo.all(Post, Query.order_by("created_at DESC"))
    end

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

    def self.create_post(post : Models::Post)
      post.body_html = Formatter.new(post.body.as(String)).complete.to_s
      _changeset = Repo.insert(post)
    end

    def self.create_post(title : String, body : String)
      post = Models::Post.new
      post.title = title
      post.body = body
      create_post(post)
    end
  end
end
