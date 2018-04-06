require "kemal"
require "kilt/slang"
require "crecto"
require "./formatter"
require "./models/*"
require "./blog"

# A macro to render a beautiful HTML page using our preferred page layout.
#
private macro render_page(filename)
  render "src/views/#{{{filename}}}.slang", "src/views/layouts/application.slang"
end

# A macro to render a JSON error message.
#
private macro render_json_error(message, status = 400)
  env.response.content_type = "application/json"
  env.response.status_code = {{ status }}
  { message: {{ message }} }.to_json
end

# A macro to render an object that hopefully respons to #to_json... as JSON.
#
private macro render_json(obj)
  env.response.content_type = "application/json"
  {{ obj }}.to_json
end

private macro embed_file(name)
  `cat {{ name }}`
end

module Crankypants
  module Web
    Post = Models::Post

    def self.run
      # This is our self-contained Vue app that you use for posting,
      # reading your feed, et al. OMG MAGICKS!
      #
      # We need to handle both /app and /app/* because for some reason,
      # the splat argument is handled slightly differently in release mode.
      #
      get "/app"   { render "src/views/app.slang" }
      get "/app/*" { render "src/views/app.slang" }

      # Our root page renders this site's latest posts.
      #
      get "/" do
        posts = Blog.load_posts
        render_page "posts/index"
      end

      # This is where we render individual posts.
      #
      get "/posts/:id" do |env|
        post = Blog.load_post(env.params.url["id"].to_i)
        render_page "posts/show"
      end

      # We compile our Webpack bundle into this app to serve
      # it directly. Yes, this is sick and twisted, but the goal
      # is to have a single self-contained executable, so there
      # you go.
      #
      {% if flag?(:release) %}
        get "/blog-bundle.js" do |env|
          env.response.headers.add "Cache-Control", "max-age=600, public"
          env.response.content_type = "text/javascript"
          Assets.get("blog-bundle.js")
        end

        get "/app-bundle.js" do |env|
          env.response.headers.add "Cache-Control", "max-age=600, public"
          env.response.content_type = "text/javascript"
          Assets.get("app-bundle.js")
        end
      {% end %}

      # JSON API!
      #
      get "/api/posts" do |env|
        render_json Blog.load_posts
      end

      post "/api/posts" do |env|
        changeset = Blog.create_post \
          title: env.params.json["title"].as(String),
          body: env.params.json["body"].as(String)

        if changeset.valid?
          render_json changeset.instance
        else
          render_json_error "Invalid post data."
        end
      end

      delete "/api/posts/:id" do |env|
        Blog.delete_post(env.params.url["id"].to_i)
        halt env, status_code: 204
      end

      Kemal.run
    end
  end
end
