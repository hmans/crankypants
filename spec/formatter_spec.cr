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
end
