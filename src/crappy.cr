require "http/server"
require "http/request"
require "json"

module Crappy
  class Handler(T)
    include HTTP::Handler

    def call(context : HTTP::Server::Context)
      T.call(context) || call_next(context)
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

    private def on(method : Symbol, *args)
      return true if done?

      if request.method == method.to_s.upcase
        within *args do |*params|
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

    private def within(part : Array(String | Symbol), *args)
      part.each do |p|
        return true if within(p, *args) { |*a| yield *a }
      end
    end

    private def within(part : Nil, *args)
      return true if done?

      yield
    end

    private def within(part : Symbol, *args)
      within(":#{part}", *args) { |*a| yield *a }
    end

    private def within(part : String)
      return true if done?

      returning = false
      buffer    = [] of String
      params    = {} of String => String?
      parts     = part.split("/").reject(&.blank?)

      parts.each do |p|
        break unless match_data = next_part_matches?(p)
        buffer << remaining_parts.shift
        params.merge!(match_data.named_captures)
      end

      if buffer.size == parts.size
        returning = yield(params)
      end

      @remaining_parts = buffer + remaining_parts

      returning
    end

    # Invoke the given block regardless of how many remaining parts are
    # still waiting to be processed. The array containing the remaining
    # path parts will be passed as an argument to the given block.
    #
    private def splat
      splat = remaining_parts.dup
      remaining_parts.clear
      yield splat
      remaining_parts.concat(splat)
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
