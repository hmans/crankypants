require "crappy"
require "../../../tools/atom_feed"
require "../helpers"

module Crankypants::Web::Routers
  class Blog < Crappy::Router
    include Helpers

    Post = Models::Post

    def call
      get do
        render html: PostView.index(Post.all)
      end

      get "posts.atom" do
        uri = URI.parse("http://#{request.host_with_port}/")
        posts = Post.all(limit: 15)

        feed = ATOM.build do |feed|
          feed.title Crankypants.settings.site_title
          feed.link URI.join(uri, "/posts.atom").to_s, rel: "self"
          feed.link URI.join(uri, "/").to_s
          feed.id URI.join(uri, "/").to_s
          feed.updated posts.map { |p| p.updated_at.not_nil! }.max

          feed.author do |author|
            author.name Crankypants.settings.site_title
            author.uri URI.join(uri, "/").to_s
          end

          posts.each do |post|
            feed.entry do |entry|
              entry.id URI.join(uri, post.url).to_s
              entry.title post.title.presence || "Post from #{post.created_at}"
              entry.link URI.join(uri, post.url).to_s
              entry.updated post.updated_at || Time.now
              entry.content post.body_html || ""
            end
          end
        end

        render xml: feed
      end

      within "posts" do
        get :id do |params|
          post_id = params["id"].not_nil!.to_i
          render html: PostView.show(Data.load_post(post_id))
        end
      end
    end
  end
end
