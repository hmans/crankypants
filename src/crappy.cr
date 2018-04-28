class HTTP::Request
  # property url_params : Hash(String, String)?
end

module Crappy
  module Routing
    private macro crappy
      request = context.request
      response = context.response
      parts = request.path.split('/').reject(&.blank?)

      {{ yield }}
    end

    private macro part_to_regex(part)
      Regex.new("\\A" + {{ part }}.gsub(/:(\w+)/, "(?<\\1>.+)") + "\\Z")
    end

    private macro within(part = nil)
      {% if part %}
        if parts.any? && (md = part_to_regex({{ part }}).match(parts[0]))
          # Extract named captures into params... for now
          params = md.named_captures

          # With the next path part removed, execute the given block
          buffer = parts.shift
          {{ yield }}
          parts.unshift buffer
        end
      {% else %}
        {{ yield }}
      {% end %}
    end

    private macro on(method, part)
      if request.method == "{{ method.id.upcase }}"
        within {{ part }} do
          # Only execute the given block when no further parts are available.
          if parts.empty?
            # Execute the given block and return, preventing remaining
            # crappy code to tun.
            {{ yield }}
            return
          end
        end
      end
    end

    {% for method in [:get, :put, :post, :patch, :delete] %}
      private macro {{ method.id }}(part = nil)
        on {{ method }}, \{{ part }} { \{{ yield }} }   # I'm not kidding
      end
    {% end %}
  end

  module Rendering
    private macro serve(output = nil, status = 200, content_type = "text/html", template = nil, json = nil)
      # Set response status code
      {% if status %}
        response.status_code = {{ status }}
      {% end %}

      # Set response content type
      {% if content_type %}
        response.content_type = {{ content_type }}
      {% end %}

      # Render response body
      {% if template %}
        response.print(Kilt.render({{ template }}))
      {% elsif json %}
        response.content_type = "application/json"
        response.print({{ json }}.to_json)
      {% elsif output == :nothing %}
        # nothing!
      {% elsif output %}
        response.print({{ output }})
      {% end %}
    end
  end
end
