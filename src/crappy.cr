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

  class Router
    property context : HTTP::Server::Context
    property request : HTTP::Request
    property response : HTTP::Server::Response
    property remaining_parts : Array(String)

    def self.call(*args)
      new(*args).call
    end

    def initialize(@context)
      @request = @context.request
      @response = @context.response
      @remaining_parts = @request.path.split('/').reject(&.blank?)
      @request_served = false
    end

    def call
      raise "Implement me"
    end

    private def render(object = nil, text = nil, html = nil, json = nil, content_type = nil, status = 200)
      response.status_code = status

      if object == :nothing
        # noop...
      elsif html
        response.content_type = content_type || "text/html"
        response << html
      elsif text
        response.content_type = content_type || "text/plain"
        response << text
      elsif json
        response.content_type = content_type || "application/json"
        response << json.to_json
      elsif object
        response << object
      end

      @request_served = true
    end

    private def on(method : Symbol, part : String | Nil = nil)
      return true if done?

      if request.method == method.to_s.upcase
        within part do |*params|
          # If no parts are remaining, this is our target path, and we should
          # totally execute the given block and serve that request, yo.
          if remaining_parts.empty?
            yield *params
            return @request_served
          end
        end
      end

      false
    end

    private def within(part : Nil)
      return true if done?

      yield
    end

    private def within(part : String)
      return true if done?

      # If the next part of the path matches, let's execute that block.
      if match_data = next_part_matches?(part)
        buffer = remaining_parts.shift
        yield match_data.named_captures
        remaining_parts.unshift(buffer)
      end
    end

    private def next_part_matches?(part)
      part_to_regex(part).match(remaining_parts.first) if remaining_parts.any?
    end

    private def part_to_regex(part : String)
      Regex.new("\\A" + part.gsub(/:(\w+)/, "(?<\\1>.+)") + "\\Z")
    end

    def request_served?
      @request_served
    end

    def done?
      request_served?
    end

    {% for method in [:get, :put, :post, :patch, :delete] %}
      def {{ method.id }}(part = nil)
        on({{ method }}, part) { |*p| yield(*p) }
      end
    {% end %}
  end
end
