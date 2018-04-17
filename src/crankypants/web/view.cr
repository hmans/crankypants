require "./helpers"

module Crankypants
  module Web
    module View
      include Helpers

      # Render a partial (without a template)
      macro render_partial(filename)
        render "src/crankypants/web/views/#{{{filename}}}.slang"
      end

      # A macro to render a beautiful HTML page using our preferred page layout.
      #
      macro render_page(filename, layout = "blog")
        render "src/crankypants/web/views/#{{{filename}}}.slang", "src/crankypants/web/views/layouts/{{ layout.id }}.slang"
      end
    end
  end
end
