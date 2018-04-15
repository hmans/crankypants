require "kemal"
require "./helpers"

module Crankypants::Web::App
  include Helpers

  def self.mount
    before_all "/app/*" do |context|
      protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"]
    end

    # This is our self-contained Vue app that you use for posting,
    # reading your feed, et al. OMG MAGICKS!
    #
    # We need to handle both /app and /app/* because for some reason,
    # the splat argument is handled slightly differently in release mode.
    #
    get "/app"   { render "src/views/app.slang" }
    get "/app/*" { render "src/views/app.slang" }

    # We compile our Webpack bundle into this app to serve
    # it directly. Yes, this is sick and twisted, but the goal
    # is to have a single self-contained executable, so there
    # you go.
    #
    {% if flag?(:release) %}
      get "/blog-bundle.js" do |env|
        env.response.headers.add "Cache-Control", "max-age=600, public"
        env.response.content_type = "text/javascript"
        Assets.get("blog-bundle.js").gets_to_end
      end

      get "/app-bundle.js" do |env|
        env.response.headers.add "Cache-Control", "max-age=600, public"
        env.response.content_type = "text/javascript"
        Assets.get("app-bundle.js").gets_to_end
      end
    {% end %}
  end
end
