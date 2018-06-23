require "crappy"
require "crappy/authentication"

require "../input_mappings"
require "../helpers"
require "../../models/*"
require "../views/*"

module Crankypants::Web::Routers
  class Api < Crappy::Router
    include Helpers
    include Crappy::Authentication

    Post = Models::Post

    def call
      within "api" do
        protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"] do
          within "posts" do
            get do
              render json: Post.all
            end

            post do
              input = InputMappings::Post.from_json(request.body.not_nil!)

              changeset = Post.create \
                title: input.title,
                body:  input.body

              changeset.valid? ?
                render json: changeset.instance :
                render_json_error "Invalid post data."
            end

            within :id do |params|
              post_id = params["id"].not_nil!.to_i

              delete do
                Post.delete(post_id)
                render :nothing, status: 204
              end

              patch do
                post  = Post.load_one(post_id)
                input = InputMappings::Post.from_json(request.body.not_nil!)

                post.title = input.title
                post.body  = input.body
                changeset  = Post.update(post)

                changeset.valid? ?
                  render json: changeset.instance :
                  render_json_error "Invalid post data."
              end
            end
          end
        end
      end
    end
  end
end
