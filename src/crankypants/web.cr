require "kilt"
require "kilt/slang"
require "http/server"
require "crecto"

require "../../crappy"

require "./formatter"
require "./models/*"
require "./data"
require "./version"
require "./web/*"
require "./web/views/*"

{% if flag?(:release) %}
require "./assets"
{% end %}

module Crankypants
  module Web
    Post = Models::Post

    def self.run
      puts ["Welcome to ", "CrankyPants".colorize(:white), "! ", ":D ".colorize(:yellow), "(#{Crankypants::VERSION})".colorize(:dark_gray)].join
      puts ["-> ".colorize(:green), "Your blog: ", "http://localhost:3000/".colorize(:cyan)].join

      # We only want to mount /app and /api if the required environment
      # variables are available.
      #
      if ENV["CRANKY_LOGIN"]? && ENV["CRANKY_PASSWORD"]?
        puts ["-> ".colorize(:green), "Your app:  ", "http://localhost:3000/app/".colorize(:cyan)].join
      else
        puts ["-> ".colorize(:yellow), "/app".colorize(:white), " and ", "/api".colorize(:white), " are disabled. Please provide CRANKY_LOGIN and CRANKY_PASSWORD!"].join
      end

      puts ["Enjoy! ", "<3<3<3".colorize(:red)].join
      puts

      HTTP::Server.new("0.0.0.0", 3000, [
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        Handler.new,
        HTTP::StaticFileHandler.new("./public/"),
      ]).listen
    end

    class Handler
      include HTTP::Handler
      include Crappy::Routing
      include Crappy::Rendering

      module InputMappings
        class CreatePost
          JSON.mapping \
            title: String,
            body: String
        end
      end

      def call(context)
        crappy do
          get do
            PostView.index Data.load_posts
          end

          within "posts" do
            get ":id" do
              PostView.show Data.load_post(params["id"].not_nil!.to_i)
            end
          end

          get "app" do
            render_template "src/crankypants/web/views/app.slang"
          end

          within "api" do
            within "posts" do
              get do
                render_json Data.load_posts
              end

              post do
                input = InputMappings::CreatePost
                  .from_json(request.body.not_nil!)

                changeset = Data.create_post \
                  title: input.title,
                  body: input.body

                if changeset.valid?
                  render_json changeset.instance
                else
                  render_json_error "Invalid post data."
                end
              end

              within ":id" do
                delete do
                  Data.delete_post(params["id"].not_nil!.to_i)
                  response.status_code = 204
                  ""
                end
              end
            end
          end
        end

        call_next(context)
      end
    end
  end
end
