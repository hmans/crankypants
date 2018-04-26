module Crappy
  module Routing
    private macro crappy
      request = context.request
      response = context.response
      parts = request.path.split('/').reject(&.blank?)

      {{ yield }}
    end

    private macro next_part_matches?(part)
      parts.any? && parts[0] == {{ part }}
    end

    private macro within(part)
      if next_part_matches?({{ part }})
        buffer = parts.shift
        {{ yield }}
        parts.unshift buffer
      end
    end

    private macro on(method, part)
      if request.method == "{{ method.id.upcase }}"
        within {{ part }} do
          # Only execute the given block when no further parts are available.
          if parts.empty?
            {{ yield }}
            return
          end
        end
      end
    end

    {% for method in [:get, :put, :post, :patch, :delete] %}
      private macro {{ method.id }}(part)
        on :get, \{{ part }} { \{{ yield }} }   # I'm not kidding
      end
    {% end %}
  end

  module Rendering
    private macro render_json(thing)
      response.content_type = "application/json"
      response.print {{ thing }}.to_json
    end
  end
end
