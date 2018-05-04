require "spec_helper"

describe "dummy HTTP :-b", type: :feature do
  it "works" do
    visit "/"
    expect(page).to have_text("My Crankypants")
  end
end
