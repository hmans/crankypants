require "uri"

class URI
  def self.join(origin : URI | String, other : URI | String)
    origin = URI.parse(origin) unless origin.is_a?(URI)
    other  = URI.parse(other)  unless other.is_a?(URI)

    origin.dup.tap do |result|
      result.path = other.path

      if other.host
        result.scheme = other.scheme
        result.host = other.host
        result.port = other.port
      end
    end
  end
end
