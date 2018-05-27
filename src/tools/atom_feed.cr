# Here's a little ATOM module that we could eventually extract
# into a shard. Woohoo!
module ATOM
  def self.build
    output = String::Builder.new
    xml = XML::Builder.new(output)
    xml.indent = 2

    ATOM::FeedBuilder.new(xml).build do |feed|
      yield feed
    end

    output.to_s
  end


  module Shortcuts
    def field(name : String, value : String? = nil, **opts)
      @xml.element(name, **opts) do
        if value
          @xml.text value
        end
      end
    end

    def text_field(name : String, value : String, **opts)
      field name, value, **opts
    end
  end

  module CommonBuilderMethods
    include Shortcuts

    def id(id : String)
      text_field "id", id
    end

    def title(title : String)
      text_field "title", title
    end

    def link(url : String)
      return if url.nil? || url.blank?
      field "link", href: url, rel: "self"
    end

    def updated(t : Time)
      return if t.nil?
      text_field "updated", t.to_iso8601
    end

    def author
      @xml.element "author" do
        yield PersonBuilder.new(@xml)
      end
    end
  end

  class FeedBuilder
    include CommonBuilderMethods

    def initialize(@xml : XML::Builder)
    end

    def build
      @xml.document do
        @xml.element "feed", xmlns: "http://www.w3.org/2005/Atom" do
          yield self
        end
      end
    end

    def entry
      @xml.element "entry" do
        yield EntryBuilder.new(@xml)
      end
    end
  end

  class EntryBuilder
    include CommonBuilderMethods

    def initialize(@xml : XML::Builder)
    end

    def content(html : String)
      field "content", html, type: "html"
    end
  end

  class PersonBuilder
    include Shortcuts

    def initialize(@xml : XML::Builder)
    end

    def name(name : String)
      text_field "name", name
    end

    def uri(uri : String)
      text_field "uri", uri
    end
  end
end
