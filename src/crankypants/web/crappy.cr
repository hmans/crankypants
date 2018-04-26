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
          buffer = parts.shift
          params = md.named_captures
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
            output = ->{
              {{ yield }}
            }.call
            response.print(output) if output
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
    private macro render_json(thing)
      response.content_type = "application/json"
      {{ thing }}.to_json
    end

    private macro render_template(filename)
      Kilt.render {{ filename }}
    end
  end
end
