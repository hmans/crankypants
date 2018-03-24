module Crankypants
  class Post
    property title : String
    property body : String

    def initialize(@title, @body)
    end

    def self.load_from_database(db, key)
      attrs = db.query_one "select title, body from posts where key = ?", key, as: { String, String }
      new(*attrs)
    end
  end
end
