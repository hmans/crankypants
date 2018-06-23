require "crecto"
require "../repo"
require "../formatter"

macro class_methods
  module ClassMethods
    {{ yield }}
  end

  extend ClassMethods
end

module Crankypants::Models
  Query = Crecto::Repo::Query
  Multi = Crecto::Multi

  class Post < Crecto::Model
    schema "posts" do
      field :title, String
      field :body, String
      field :body_html, String
    end

    validate_required [:body]
    validate_length :body, min: 1

    def url
      "/posts/#{id}"
    end

    class_methods do
      def count
        Repo.aggregate(self, :count, :id).as(Int64)
      end

      def all(limit : Int32? = nil)
        query = Query
          .order_by("created_at DESC")
          .limit(limit)

        Repo.all(self, query)
      end

      def create(post : Post)
        post.body_html = Formatter.new(post.body.as(String)).complete.to_s
        Repo.insert(post)
      end

      def create(title : String, body : String)
        post = Post.new
        post.title = title
        post.body = body
        create(post)
      end
    end
  end
end
