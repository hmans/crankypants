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

    def self.load_posts(limit : Int32? = nil)
      query = Query
        .order_by("created_at DESC")
        .limit(limit)

      Repo.all(Post, query)
    end

    def self.load_post(id : Int32)
      Repo.get!(Post, id)
    end

    def self.delete_post(id : Int32)
      Repo.get!(Post, id)
        .then { |post| Repo.delete(post) }
    end

    def self.update_post(post : Models::Post)
      post
        .tap  { |post| post.body_html = Formatter.new(post.body.as(String)).complete.to_s }
        .then { |post| Repo.update(post) }
    end

    def self.create_post(post : Models::Post)
      post
        .tap  { |post| post.body_html = Formatter.new(post.body.as(String)).complete.to_s }
        .then { |post| Repo.insert(post) }
    end

    def self.create_post(title : String, body : String)
      Models::Post.new
        .tap  { |post| post.title = title }
        .tap  { |post| post.body = body }
        .then { |post| create_post(post) }
    end
  end
end
