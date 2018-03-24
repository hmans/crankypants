require "sqlite3"

module Crankypants
  module Database
    extend self

    def open
      DB.open "sqlite3://./data.db"
    end

    def close(db)
      db.close
    end

    def load_post(db, key)
      db.query_one "select title, body from posts where key = ?", key, as: { String, String }
    end
  end
end
