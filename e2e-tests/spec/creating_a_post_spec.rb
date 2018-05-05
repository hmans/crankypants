require "spec_helper"

describe "creating a post", type: :feature do
  specify do
    on :alice do
      visit "/app"

      fill_in "post_body", with: "Hello world"
      click_on "Save Post"

      visit "/"
      expect(page).to have_css(:article, text: "Hello world")
    end

    on :bob do
      visit "/"
      expect(page).to have_text("And I Am Bob")
    end
  end
end
