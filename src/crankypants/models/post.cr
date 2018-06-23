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

    def before_save
      self.body_html = Formatter.new(body.as(String)).complete.to_s
    end

    class_methods do
      def count
        Repo.aggregate(self, :count, :id).as(Int64)
      end

      def load_all(limit : Int32? = nil)
        query = Query
          .order_by("created_at DESC")
          .limit(limit)

        Repo.all(self, query)
      end

      def create(post : Post)
        post.before_save
        Repo.insert(post)
      end

      def create(title : String, body : String)
        post = Post.new
        post.title = title
        post.body = body
        create(post)
      end

      def load_one(id : Int32)
        Repo.get!(Post, id)
      end

      def delete(id : Int32)
        post = Repo.get!(self, id)
        Repo.delete(post)
      end

      def update(post : self)
        post.before_save
        Repo.update(post)
      end
    end
  end
end
