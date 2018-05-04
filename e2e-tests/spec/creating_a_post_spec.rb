require "spec_helper"

describe "creating a post", type: :feature do
  specify do
    visit "/app"

    fill_in "post_body", with: "Hello world"
    click_on "Save Post"

    visit "/"
    expect(page).to have_css(:article, text: "Hello world")
  end
end
