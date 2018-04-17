require "./spec_helper"
require "../crankypants/data"

Data = Crankypants::Data
Repo = Crankypants::Repo
Post = Crankypants::Models::Post

describe Crankypants::Data do
  describe ".create_post" do
    it "creates a new post" do
      post_count = Data.count_posts
      Data.create_post(title: "Hello", body: "world")
      Data.count_posts.should eq(post_count + 1)
    end
  end
end
