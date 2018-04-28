module Crankypants
  module Web
    module Helpers
      private macro serve_json_error(message, status = 400)
        serve json: { message: {{ message }} }, status: 400
      end

      private macro serve_static_asset(name, content_type)
        response.headers.add "Cache-Control", "max-age=600, public"

        if request.headers["Accept-Encoding"] =~ /gzip/
          response.headers.add "Content-Encoding", "gzip"
          serve Assets.get("{{ name.id }}.gz").gets_to_end, content_type: {{ content_type }}
        else
          serve Assets.get("{{ name.id }}").gets_to_end, content_type: {{ content_type }}
        end
      end
    end
  end
end
