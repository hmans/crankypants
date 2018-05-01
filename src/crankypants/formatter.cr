require "markd"

class Formatter
  def initialize(@input : String)
    @current = @input
  end

  def complete
    markdown
  end

  def markdown
    @current = Markd.to_html(@current)
  end

  def to_s : String
    @current
  end
end
