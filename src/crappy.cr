# class HTTP::Request
#   # property url_params : Hash(String, String)?
# end
#
# class HTTP::Server::Context
#   def remaining_path
#     @_remaining_path ||= begin
#       request.path.split('/').reject(&.blank?)
#     end
#   end
# end
#

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

# module Crappy
#   module Routing
#     private macro crappy
#       request = context.request
#       response = context.response
#       parts = request.path.split('/').reject(&.blank?)
#
#       {{ yield }}
#     end
#
#     private macro part_to_regex(part)
#       Regex.new("\\A" + {{ part }}.gsub(/:(\w+)/, "(?<\\1>.+)") + "\\Z")
#     end
#
#     private macro within(part = nil)
#       {% if part %}
#         if parts.any? && (md = part_to_regex({{ part }}).match(parts[0]))
#           # Extract named captures into params... for now
#           params = md.named_captures
#
#           # With the next path part removed, execute the given block
#           buffer = parts.shift
#           {{ yield }}
#           parts.unshift buffer
#         end
#       {% else %}
#         {{ yield }}
#       {% end %}
#     end
#
#     private macro on(method, part)
#       if request.method == "{{ method.id.upcase }}"
#         within {{ part }} do
#           # Only execute the given block when no further parts are available.
#           if parts.empty?
#             # Execute the given block and return, preventing remaining
#             # crappy code to tun.
#             {{ yield }}
#             return
#           end
#         end
#       end
#     end
#
#     {% for method in [:get, :put, :post, :patch, :delete] %}
#       private macro {{ method.id }}(part = nil)
#         on {{ method }}, \{{ part }} { \{{ yield }} }   # I'm not kidding
#       end
#     {% end %}
#   end
#
#   module Serving
#     private macro serve(output = nil, status = 200, content_type = "text/html", template = nil, json = nil)
#       # Set response status code
#       {% if status %}
#         response.status_code = {{ status }}
#       {% end %}
#
#       # Set response content type
#       {% if content_type %}
#         response.content_type = {{ content_type }}
#       {% end %}
#
#       # Render response body
#       {% if template %}
#         response.print(Kilt.render({{ template }}))
#       {% elsif json %}
#         response.content_type = "application/json"
#         response.print({{ json }}.to_json)
#       {% elsif output == :nothing %}
#         # nothing!
#       {% elsif output %}
#         response.print({{ output }})
#       {% end %}
#
#       # Always return, ending request processing.
#       return
#     end
#   end
#
#   module Authentication
#     private macro protect_with(username, password)
#       auth_info = if request.headers["Authorization"]? && request.headers["Authorization"] =~ /^Basic (.+)$/
#         Base64.decode_string($1).split(':')
#       else
#         [nil, nil]
#       end
#
#       if [{{username}}, {{password}}] != auth_info
#         # Authorization failed...
#         response.headers["WWW-Authenticate"] = "Basic realm=\"Crankypants!\""
#         serve "Please log in.", status: 401
#       end
#     end
#   end
# end
