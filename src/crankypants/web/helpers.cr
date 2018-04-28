{% if flag?(:release) %}
require "./assets"
{% end %}

module Crankypants
  module Web
    module Helpers
      private macro serve_json_error(message, status = 400)
        serve json: { message: {{ message }} }, status: 400
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
          serve Assets.get({{ name }} + ".gz").gets_to_end, content_type: content_type
        else
          serve Assets.get({{ name }}).gets_to_end, content_type: content_type
        end
      end
    end
  end
end
