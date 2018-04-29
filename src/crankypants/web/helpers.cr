require "./assets"

module Crankypants
  module Web
    module Helpers
      private macro render_json_error(message, status = 400)
        render json: { message: {{ message }} }, status: {{ status }}
      end

      private macro serve_static_asset(name, cache = true)
        content_type = case File.extname({{ name }})
          when ".css" then "text/css"
          when ".js"  then "application/javascript"
          else        "application/octet-stream"
        end

        {% if cache %}
          response.headers.add "Cache-Control", "max-age=#{30*24*60*60}, public"
        {% end %}

        if request.headers["Accept-Encoding"] =~ /gzip/
          response.headers.add "Content-Encoding", "gzip"
          render Assets.get({{ name }} + ".gz").gets_to_end, content_type: content_type
        else
          render Assets.get({{ name }}).gets_to_end, content_type: content_type
        end
      end
    end
  end
end
