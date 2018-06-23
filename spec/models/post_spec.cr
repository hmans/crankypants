require "../spec_helper"
require "../../src/crankypants/models/post"

Repo = Crankypants::Repo
Post = Crankypants::Models::Post

describe Crankypants::Models::Post do
  describe ".create" do
    it "creates a new post" do
      post_count = Post.count
      Post.create(title: "Hello", body: "world")
      Post.count.should eq(post_count + 1)
    end
  end
end
