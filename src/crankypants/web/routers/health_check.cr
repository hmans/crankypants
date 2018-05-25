require "../../../crappy"

module Crankypants::Web::Routers
  class HealthCheck < Crappy::Router
    def call
      get "ready" do
        render :nothing, status: 200
      end
    end
  end
end
