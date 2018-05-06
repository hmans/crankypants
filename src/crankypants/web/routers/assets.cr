require "../../../crappy"
require "../../../crappy/authentication"

module Crankypants::Web::Routers
  class Assets < Crappy::Router
    include Helpers
    include Crappy::Authentication

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
