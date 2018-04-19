module Crankypants::Web::Helpers
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

  macro serve_static_asset(name)
    if env.request.headers["Accept-Encoding"] =~ /gzip/
      env.response.headers.add "Content-Encoding", "gzip"
      Assets.get("{{ name.id }}.gz").gets_to_end
    else
      Assets.get("{{ name.id }}").gets_to_end
    end
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
