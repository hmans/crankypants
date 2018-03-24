require "kemal"

get "/" do
  "Blog LOL!"
end

module Crankypants
  module Web
    extend self

    def run
      Kemal.run
    end
  end
end
