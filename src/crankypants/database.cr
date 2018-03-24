require "sqlite3"

module Crankypants
  module Database
    def self.open
      DB.open "sqlite3://./data.db"
    end

    def self.close(db)
      db.close
    end

    def self.load_post(db, key)
      db.query_one "select title, body from posts where key = ?", key, as: { String, String }
    end
  end
end
