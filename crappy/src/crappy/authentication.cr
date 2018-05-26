module Crappy
  module Authentication
    def protect_with(username, password)
      auth_info = if request.headers["Authorization"]? && request.headers["Authorization"] =~ /^Basic (.+)$/
        Base64.decode_string($1).split(':')
      else
        [nil, nil]
      end

      if [username, password] == auth_info
        yield
      else
        # Authorization failed...
        response.headers["WWW-Authenticate"] = "Basic realm=\"Crankypants!\""
        render text: "Please log in.", status: 401
      end
    end
  end
end
