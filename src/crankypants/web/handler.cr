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
    def call
      serve_blog || serve_api || serve_app || serve_foo
    end

    def serve_blog
      get do
        render html: PostView.index(Data.load_posts)
      end

      within "posts" do
        get ":id" do |params|
          render html: PostView.show(Data.load_post(params["id"].not_nil!.to_i))
        end
      end
    end

    def serve_api
      within "api" do
        # protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]

        within "posts" do
          get do
            render json: Data.load_posts
          end
        end
      end
    end

    def serve_app
      within "app" do
        # protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]
        render text: Kilt.render("src/crankypants/web/views/app.slang"), content_type: "text/html"
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

    # def call(context)
    #   crappy do
    #     {% if flag?(:release) %}
    #       serve_static_assets
    #     {% end %}
    #
    #     serve_blog
    #     serve_app
    #     serve_api
    #   end
    #
    #   call_next(context)
    # end

    # private macro serve_static_assets
    #   within "assets" do
    #     within ":version" do
    #       get ":filename" do
    #         serve_static_asset "assets/#{params["filename"]}"
    #       end
    #     end
    #   end
    # end
    #
    # private macro serve_blog
    #   get do
    #     serve PostView.index(Data.load_posts)
    #   end
    #
    #   within "posts" do
    #     get ":id" do
    #       serve PostView.show(Data.load_post(params["id"].not_nil!.to_i))
    #     end
    #   end
    # end
    #
    # private macro serve_app
    #   within "app" do
    #     protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]
    #     serve template: "src/crankypants/web/views/app.slang"
    #   end
    # end
    #
    # private macro serve_api
    #   within "api" do
    #     protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]
    #
    #     within "posts" do
    #       get do
    #         serve json: Data.load_posts
    #       end
    #
    #       post do
    #         input = InputMappings::Post.from_json(request.body.not_nil!)
    #
    #         changeset = Data.create_post \
    #           title: input.title,
    #           body:  input.body
    #
    #         changeset.valid? ?
    #           serve json: changeset.instance :
    #           serve_json_error "Invalid post data."
    #       end
    #
    #       within ":id" do
    #         delete do
    #           Data.delete_post(params["id"].not_nil!.to_i)
    #           serve :nothing, status: 204
    #         end
    #
    #         patch do
    #           post  = Data.load_post(params["id"].not_nil!.to_i)
    #           input = InputMappings::Post.from_json(request.body.not_nil!)
    #
    #           post.title = input.title
    #           post.body  = input.body
    #           changeset  = Data.update_post(post)
    #
    #           changeset.valid? ?
    #             serve json: changeset.instance, status: 204 :
    #             serve_json_error "Invalid post data."
    #         end
    #       end
    #     end
    #   end
    # end
  end
end
