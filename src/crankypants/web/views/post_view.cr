require "../view"

module Crankypants
  module PostView
    include Crankypants::Web::View

    def self._post(post)
      render_partial "post_view/_post"
    end

    def self.index(posts)
      render_page "post_view/index"
    end

    def self.show(post)
      render_page "post_view/show"
    end
  end
end
