require "kemal"

get "/" do
  "Blog LOL!"
end

module Crankypants
  module Web
    def self.run
      Kemal.run
    end
  end
end
