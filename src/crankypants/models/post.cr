require "crecto"

module Crankypants::Models
  class Post < Crecto::Model
    schema "posts" do
      field :title, String
      field :body, String
      field :body_html, String
    end

    validate_required [:body]
    validate_length :body, min: 1

    def url
      "/posts/#{id}"
    end
  end
end
