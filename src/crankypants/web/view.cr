require "./helpers"

module Crankypants
  module Web
    module View
      include Crappy::Rendering

      macro render_with_layout(filename)
        content = {{ yield }}
        render_template "src/crankypants/web/views/layouts/#{{{ filename }}}.slang"
      end

      # Render a partial (without a template)
      macro render_partial(filename)
        render_template "src/crankypants/web/views/#{{{filename}}}.slang"
      end

      # A macro to render a beautiful HTML page using our preferred page layout.
      #
      macro render_page(filename, content_type = "text/html")
        {% if content_type %}
          response.content_type = {{ content_type }}
        {% end %}
        render_template "src/crankypants/web/views/#{{{ filename }}}.slang"
      end
    end
  end
end
