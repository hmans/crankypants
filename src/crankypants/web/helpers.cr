module Crankypants::Web::Helpers
  # A macro to render a beautiful HTML page using our preferred page layout.
  #
  macro render_page(filename)
    render "src/views/#{{{filename}}}.slang", "src/views/layouts/application.slang"
  end

  # A macro to render a JSON error message.
  #
  macro render_json_error(message, status = 400)
    env.response.content_type = "application/json"
    env.response.status_code = {{ status }}
    { message: {{ message }} }.to_json
  end

  # A macro to render an object that hopefully respons to #to_json... as JSON.
  #
  macro render_json(obj)
    env.response.content_type = "application/json"
    {{ obj }}.to_json
  end

  private macro protect_with(username, password)
    if context.request.headers["Authorization"]? && context.request.headers["Authorization"] =~ /^Basic (.+)$/
      u, p = Base64.decode_string($1).split(':')
      next if {{username}} == u && {{password}} == p
    end

    # Authorization failed...
    context.response.headers["WWW-Authenticate"] = "Basic realm=\"Crankypants!\""
    halt context, status_code: 401, response: "Please log in."
  end
end
