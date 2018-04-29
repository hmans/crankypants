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
  class Router
    property context : HTTP::Server::Context
    property request : HTTP::Request
    property response : HTTP::Server::Response
    property remaining_parts : Array(String)

    def initialize(@context)
      @request = @context.request
      @response = @context.response
      @remaining_parts = @request.path.split('/').reject(&.blank?)
      @request_served = false
    end

    def call
      raise "Implement me"
    end

    private def on(method : Symbol, part : String | Nil = nil)
      return if done?

      if request.method == method.to_s.upcase
        within part do
          # If no parts are remaining, this is our target path, and we should
          # totally execute the given block and serve that request, yo.
          if remaining_parts.empty?
            yield
            @request_served = true
          end
        end
      end
    end

    private def within(part : Nil)
      return if done?

      yield
    end

    private def within(part : String)
      return if done?

      # If the next part of the path matches, let's execute that block.
      if next_part_matches?(part)
        buffer = remaining_parts.shift
        yield
        remaining_parts.unshift(buffer)
      end
    end

    private def next_part_matches?(part)
      remaining_parts.any? && remaining_parts.first == part
    end

    def request_served?
      @request_served
    end

    def done?
      request_served?
    end

    {% for method in [:get, :put, :post, :patch, :delete] %}
      private macro {{ method.id }}(part = nil)
        on {{ method }}, \{{ part }} { \{{ yield }} }
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
