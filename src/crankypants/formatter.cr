require "markd"
require "autolink"

private class AutolinkingRenderer < Markd::HTMLRenderer
  def text(node, entering)
    lit Autolink.auto_link(node.text)
  end
end

module Crankypants
  class Formatter
    def initialize(@input : String)
      @current = @input
      @options = Markd::Options.new(smart: true)
      @renderer = AutolinkingRenderer.new(@options)
    end

    def complete
      markdown
    end

    def markdown
      document = Markd::Parser.parse(@current, @options)
      @current = @renderer.render(document)
    end

    def to_s : String
      @current
    end
  end
end
