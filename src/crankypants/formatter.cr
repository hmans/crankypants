require "markdown"

class Formatter
  def initialize(@input : String)
    @current = @input
  end

  def markdown
    @current = Markdown.to_html(@current)
  end

  def to_s : String
    @current
  end
end
