require "kilt"
require "kilt/slang"
require "../../../crappy"
require "../formatter"
require "../models/*"
require "../data"
require "./views/*"
require "./helpers"
require "./input_mappings"

module Crankypants::Web
  class Router < Crappy::Router
    include Helpers
    include Crappy::Authentication

    def call
      serve_static_assets || serve_blog || serve_api || serve_app || serve_foo
    end

    def serve_static_assets
      {% if flag?(:release) %}
        within "assets" do
          within ":version" do
            get ":filename" do |params|
              serve_static_asset "assets/#{params["filename"]}"
            end
          end
        end
      {% end %}
    end

    def serve_blog
      get do
        render html: PostView.index(Data.load_posts)
      end

      within "posts" do
        get ":id" do |params|
          post_id = params["id"].not_nil!.to_i
          render html: PostView.show(Data.load_post(post_id))
        end
      end
    end

    def serve_api
      within "api" do
        protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"] do
          within "posts" do
            get do
              render json: Data.load_posts
            end

            post do
              input = InputMappings::Post.from_json(request.body.not_nil!)

              changeset = Data.create_post \
                title: input.title,
                body:  input.body

              changeset.valid? ?
                render json: changeset.instance :
                render_json_error "Invalid post data."
            end

            within ":id" do |params|
              post_id = params["id"].not_nil!.to_i

              delete do
                Data.delete_post(post_id)
                render :nothing, status: 204
              end

              patch do
                post  = Data.load_post(post_id)
                input = InputMappings::Post.from_json(request.body.not_nil!)

                post.title = input.title
                post.body  = input.body
                changeset  = Data.update_post(post)

                puts "patching!"

                changeset.valid? ?
                  render json: changeset.instance :
                  render_json_error "Invalid post data."
              end
            end
          end
        end
      end
    end

    def serve_app
      within "app" do
        protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"] do
          render text: Kilt.render("src/crankypants/web/views/app.slang"), content_type: "text/html"
        end
      end
    end

    def serve_foo
      get "foo" do
        render text: "Foo?"
      end
    end
  end

  class Handler
    include HTTP::Handler

    def call(context)
      Router.call(context) || call_next(context)
    end
  end
end
