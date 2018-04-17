require "kemal"
require "kilt/slang"
require "crecto"
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
        Api.mount
        App.mount
        puts ["-> ".colorize(:green), "Your app:  ", "http://localhost:3000/app/".colorize(:cyan)].join
      else
        puts ["-> ".colorize(:yellow), "/app".colorize(:white), " and ", "/api".colorize(:white), " are disabled. Please provide CRANKY_LOGIN and CRANKY_PASSWORD!"].join
      end

      puts ["Enjoy! ", "<3<3<3".colorize(:red)].join
      puts

      # We definitely always want to mount the public-facing blog.
      #
      Blog.mount

      # LET'S DO THIS!
      #
      Kemal.run
    end
  end
end
