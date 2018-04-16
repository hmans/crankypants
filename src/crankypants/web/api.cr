require "kemal"
require "./helpers"

module Crankypants::Web::Api
  include Helpers

  def self.mount
    before_all do |context|
      if context.request.path.starts_with?("/api")
        protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]
      end
    end

    # JSON API!
    #
    get "/api/posts" do |env|
      render_json Data.load_posts
    end

    post "/api/posts" do |env|
      changeset = Data.create_post \
        title: env.params.json["title"].as(String),
        body: env.params.json["body"].as(String)

      if changeset.valid?
        render_json changeset.instance
      else
        render_json_error "Invalid post data."
      end
    end

    delete "/api/posts/:id" do |env|
      Data.delete_post(env.params.url["id"].to_i)
      halt env, status_code: 204
    end

    patch "/api/posts/:id" do |env|
      post = Data.load_post(env.params.url["id"].to_i)
      post.title = env.params.json["title"].as(String)
      post.body = env.params.json["body"].as(String)

      changeset = Data.update_post(post)

      if changeset.valid?
        render_json changeset.instance
      else
        render_json_error "Invalid post data."
      end
    end
  end
end
