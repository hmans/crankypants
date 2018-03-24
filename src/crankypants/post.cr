module Crankypants
  class Post < Crecto::Model
    schema "posts" do
      field :title, String
      field :body, String
    end

    validate_required [:body]
  end
end
