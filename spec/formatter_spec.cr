require "./spec_helper"
require "../crankypants/formatter"

private def format(input)
  Formatter.new(input).complete.to_s
end

describe Formatter do
  it "renders Markdown to HTML" do
    format("Hello **world**!")
      .should eq("<p>Hello <strong>world</strong>!</p>\n")
  end

  it "keeps user-provided HTML intact" do
    format("Hello <strong>world</strong>!")
      .should eq("<p>Hello <strong>world</strong>!</p>\n")
  end

  it "doesn't render markdown contained in <pre> blocks" do
    format("<pre>**yay**</pre>")
      .should eq("<pre>**yay**</pre>\n")
  end

  pending "autolinking" do
    it "autolinks URLs" do
      format("My blog is at http://hmans.io!")
        .should eq("<p>My blog is at <a href=\"http://hmans.io\">http://hmans.io</a>!</p>\n")
    end

    it "does not change URLs in tag attributes" do
      format("<img src=\"http://hmans.io/kitten.jpg\">")
        .should eq("<img src=\"http://hmans.io/kitten.jpg\">\n")
    end

    it "does not change URLs in <pre> blocks" do
      format("<pre><code>http://hmans.io</code></pre>")
        .should eq("<pre><code>http://hmans.io</code></pre>\n")
    end
  end
end
