require "spec_helper"

describe "blog header", type: :feature do
  let(:blog) { Blog.new }

  specify do
    on :bob do
      blog.load
      expect(blog).to have_site_title
      expect(blog.site_title).to have_text("And I Am Bob")
    end
  end
end
