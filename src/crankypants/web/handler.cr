require "kilt"
require "kilt/slang"
require "../../../crappy"
require "../formatter"
require "../models/*"
require "../data"
require "./views/*"

{% if flag?(:release) %}
require "./web/assets"
{% end %}

module Crankypants::Web
  class Handler
    include HTTP::Handler
    include Crappy::Routing
    include Crappy::Rendering
    include Crappy::Authentication

    module InputMappings
      class Post
        JSON.mapping \
          title: String,
          body: String
      end
    end

    private macro serve_json_error(message, status = 400)
      serve json: { message: {{ message }} }, status: 400
    end

    private macro serve_static_asset(name, content_type)
      response.headers.add "Cache-Control", "max-age=600, public"

      if request.headers["Accept-Encoding"] =~ /gzip/
        response.headers.add "Content-Encoding", "gzip"
        serve Assets.get("{{ name.id }}.gz").gets_to_end, content_type: {{ content_type }}
      else
        serve Assets.get("{{ name.id }}").gets_to_end, content_type: {{ content_type }}
      end
    end

    def call(context)
      crappy do
        # static assets
        {% if flag?(:release) %}
          within "assets" do
            get "blog.css" { serve_static_asset "assets/blog.css", "text/css" }
            get "app.css"  { serve_static_asset "assets/app.css", "text/css" }
            get "blog-bundle.js" { serve_static_asset "assets/blog-bundle.js", "text/javascript" }
            get "app-bundle.js" { serve_static_asset "assets/app-bundle.js", "text/javascript" }
          end
        {% end %}

        get do
          serve PostView.index(Data.load_posts)
        end

        within "posts" do
          get ":id" do
            serve PostView.show(Data.load_post(params["id"].not_nil!.to_i))
          end
        end

        within "app" do
          protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]
          serve template: "src/crankypants/web/views/app.slang"
        end

        within "api" do
          protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]

          within "posts" do
            get do
              serve json: Data.load_posts
            end

            post do
              input = InputMappings::Post
                .from_json(request.body.not_nil!)

              changeset = Data.create_post \
                title: input.title,
                body: input.body

              if changeset.valid?
                serve json: changeset.instance
              else
                serve_json_error "Invalid post data."
              end
            end

            within ":id" do
              delete do
                Data.delete_post(params["id"].not_nil!.to_i)
                serve :nothing, status: 204
              end

              patch do
                post = Data.load_post(params["id"].not_nil!.to_i)

                input = InputMappings::Post.from_json(request.body.not_nil!)

                post.title = input.title
                post.body = input.body

                changeset = Data.update_post(post)

                if changeset.valid?
                  serve json: changeset.instance, status: 204
                else
                  serve_json_error "Invalid post data."
                end
              end
            end
          end
        end
      end

      call_next(context)
    end
  end
end
