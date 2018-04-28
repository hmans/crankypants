module Crankypants
  module Web
    module View
      # Render a random template
      macro render_template(filename)
        Kilt.render "src/crankypants/web/views/#{{{ filename }}}.slang"
      end

      # A macro to render a beautiful HTML page using our preferred page layout.
      #
      macro render_page(filename, layout = "blog")
        {% if layout %}
          content = render_template({{ filename }})
          render_template "layouts/#{{{ layout }}}"
        {% else %}
          render_template({{ filename }})
        {% end %}
      end
    end
  end
end
