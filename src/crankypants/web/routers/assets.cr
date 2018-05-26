require "crappy"

module Crankypants::Web::Routers
  class Assets < Crappy::Router
    include Helpers

    def call
      {% if flag?(:release) %}
        within "assets" do
          within :version do
            get :filename do |params|
              serve_static_asset "assets/#{params["filename"]}"
            end
          end
        end
      {% end %}
    end
  end
end
