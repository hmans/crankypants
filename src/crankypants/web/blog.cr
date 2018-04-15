require "kemal"
require "./helpers"

module Crankypants::Web::Blog
  include Helpers

  def self.mount
    # Our root page renders this site's latest posts.
    #
    get "/" do
      posts = Data.load_posts
      render_page "posts/index"
    end

    # This is where we render individual posts.
    #
    get "/posts/:id" do |env|
      post = Data.load_post(env.params.url["id"].to_i)
      render_page "posts/show"
    end
  end
end
