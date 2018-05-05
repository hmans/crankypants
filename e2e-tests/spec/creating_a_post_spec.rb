require "spec_helper"

describe "creating a post", type: :feature do
  let(:blog) { Blog.new }
  let(:app)  { App.new }

  specify do
    on :alice do
      # Alice publishes a new post through her app.
      app.load
      app.new_post_body.set "Hello world"
      click_on "Save Post"

      # The post should now be visible on her blog.
      blog.load
      expect(blog).to have_css(:article, text: "Hello world")
    end
  end
end
