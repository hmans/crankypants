module Crankypants::Web
  module InputMappings
    class Post
      JSON.mapping \
        title: String,
        body: String
    end
  end
end
