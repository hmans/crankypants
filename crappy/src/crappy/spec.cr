require "http/request"
require "http/client/response"
require "../crappy"

module Crappy
  class TestRequest(R)
    getter response : HTTP::Client::Response

    def initialize(@method : String, @path : String)
      io       = IO::Memory.new
      request  = HTTP::Request.new(method, path)
      response = HTTP::Server::Response.new(io)
      context  = HTTP::Server::Context.new(request, response)

      handler = Crappy::Handler(R).new
      handler.call(context)
      response.close

      io.rewind
      @response = HTTP::Client::Response.from_io(io)
    end

    {% for method in [:get, :put, :post, :patch, :delete] %}
    def self.{{ method.id }}(*args)
      new({{ method.id.stringify.upcase }}, *args)
    end
    {% end %}
  end
end
