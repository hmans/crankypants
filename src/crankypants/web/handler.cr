require "kilt"
require "kilt/slang"
require "../../../crappy"
require "../formatter"
require "../models/*"
require "../data"
require "./views/*"
require "./helpers"

{% if flag?(:release) %}
require "./web/assets"
{% end %}

module Crankypants::Web
  class Handler
    include HTTP::Handler
    include Crappy::Routing
    include Crappy::Rendering
    include Crappy::Authentication
    include Helpers

    module InputMappings
      class Post
        JSON.mapping \
          title: String,
          body: String
      end
    end

    private macro serve_static_assets
      within "assets" do
        get "blog.css" { serve_static_asset "assets/blog.css", "text/css" }
        get "app.css"  { serve_static_asset "assets/app.css", "text/css" }
        get "blog-bundle.js" { serve_static_asset "assets/blog-bundle.js", "text/javascript" }
        get "app-bundle.js" { serve_static_asset "assets/app-bundle.js", "text/javascript" }
      end
    end

    private macro serve_blog
      get do
        serve PostView.index(Data.load_posts)
      end

      within "posts" do
        get ":id" do
          serve PostView.show(Data.load_post(params["id"].not_nil!.to_i))
        end
      end
    end

    private macro serve_app
      within "app" do
        protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]
        serve template: "src/crankypants/web/views/app.slang"
      end
    end

    private macro serve_api
      within "api" do
        protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]

        within "posts" do
          get do
            serve json: Data.load_posts
          end

          post do
            input = InputMappings::Post.from_json(request.body.not_nil!)

            changeset = Data.create_post \
              title: input.title,
              body:  input.body

            changeset.valid? ?
              serve json: changeset.instance :
              serve_json_error "Invalid post data."
          end

          within ":id" do
            delete do
              Data.delete_post(params["id"].not_nil!.to_i)
              serve :nothing, status: 204
            end

            patch do
              post  = Data.load_post(params["id"].not_nil!.to_i)
              input = InputMappings::Post.from_json(request.body.not_nil!)

              post.title = input.title
              post.body  = input.body
              changeset  = Data.update_post(post)

              changeset.valid? ?
                serve json: changeset.instance, status: 204 :
                serve_json_error "Invalid post data."
            end
          end
        end
      end
    end

    def call(context)
      crappy do
        {% if flag?(:release) %}
          serve_static_assets
        {% end %}

        serve_blog
        serve_app
        serve_api
      end

      call_next(context)
    end
  end
end
