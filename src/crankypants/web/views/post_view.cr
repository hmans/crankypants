require "../view"

module Crankypants
  module PostView
    include Crankypants::Web::View

    def self._post(post)
      render_template "post_view/_post"
    end

    def self.index(posts)
      page_title = Crankypants.settings.site_title
      render_page "post_view/index"
    end

    def self.show(post)
      title = [] of String
      title << post.title.not_nil! unless post.title.not_nil!.blank?
      title << Crankypants.settings.site_title

      page_title = title.compact.join(" · ")

      render_page "post_view/show"
    end
  end
end
