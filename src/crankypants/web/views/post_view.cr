require "../view"

module Crankypants
  module PostView
    include Crankypants::Web::View

    def self._post(post)
      render_partial "post_view/_post"
    end

    macro index(posts)
      posts = {{ posts }}
      page_title = ENV.fetch "CRANKY_TITLE", "A Crankypants Site"
      PostView.render_page "post_view/index"
    end

    # def self.show(post)
    #   title = [] of String
    #   title << post.title.not_nil! unless post.title.not_nil!.blank?
    #   title << ENV["CRANKY_TITLE"]
    #
    #   page_title = title.compact.join(" · ")
    #   render_page "post_view/show"
    # end
  end
end
