require "./version"
require "./web/routers/*"
require "http/server"

module Crankypants
  module Web
    ASSET_PATH = {% if flag?(:release) %}
      "assets/#{Crankypants::GIT_COMMIT}"
    {% else %}
      "assets"
    {% end %}

    def self.run
      server = HTTP::Server.new([
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        HTTP::StaticFileHandler.new("./public/", directory_listing: false),
        Crappy::Handler(Routers::Blog).new,
        Crappy::Handler(Routers::Assets).new,
        Crappy::Handler(Routers::Api).new,
        Crappy::Handler(Routers::App).new,
        Crappy::Handler(Routers::HealthCheck).new,
      ])

      server.listen Crankypants.settings.interface, Crankypants.settings.port
    end
  end
end
