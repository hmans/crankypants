require "http/server"
require "colorize"
require "./version"
require "./web/routers/*"

module Crankypants
  module Web
    ASSET_PATH = {% if flag?(:release) %}
      "assets/#{Crankypants::GIT_COMMIT}"
    {% else %}
      "assets"
    {% end %}

    def self.print_banner
      base_url = "http://#{Crankypants.settings.interface}:#{Crankypants.settings.port}/"
      puts ["Welcome to ", "CrankyPants".colorize(:white), "! ", ":D ".colorize(:yellow), "(#{Crankypants::VERSION})".colorize(:dark_gray)].join
      puts ["-> ".colorize(:green), "Your blog: ", base_url.colorize(:cyan)].join

      # We only want to mount /app and /api if the required environment
      # variables are available.
      #
      if ENV["CRANKY_LOGIN"]? && ENV["CRANKY_PASSWORD"]?
        puts ["-> ".colorize(:green), "Your app:  ", "#{base_url}app/".colorize(:cyan)].join
      else
        puts ["-> ".colorize(:yellow), "/app".colorize(:white), " and ", "/api".colorize(:white), " are disabled. Please provide CRANKY_LOGIN and CRANKY_PASSWORD!"].join
      end

      puts ["Enjoy! ", "<3<3<3".colorize(:red)].join
      puts
    end

    def self.run
      print_banner

      HTTP::Server.new(Crankypants.settings.interface, Crankypants.settings.port, [
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        HTTP::StaticFileHandler.new("./public/", directory_listing: false),
        Crappy::Handler(Routers::Blog).new,
        Crappy::Handler(Routers::Assets).new,
        Crappy::Handler(Routers::Api).new,
        Crappy::Handler(Routers::App).new,
      ]).listen
    end
  end
end
