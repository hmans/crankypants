require "../../../crappy"
require "../../../crappy/authentication"

module Crankypants::Web::Routers
  class App < Crappy::Router
    include Helpers
    include Crappy::Authentication

    def call
      within "app" do
        protect_with ENV["CRANKY_LOGIN"], ENV["CRANKY_PASSWORD"] do
          render text: Kilt.render("src/crankypants/web/views/app.slang"), content_type: "text/html"
        end
      end
    end
  end
end
