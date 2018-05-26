require "crappy"

module Crankypants::Web::Routers
  class Blog < Crappy::Router
    include Helpers

    def call
      get do
        render html: PostView.index(Data.load_posts)
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
