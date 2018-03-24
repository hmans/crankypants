require "sqlite3"

module Crankypants
  module Database
    extend self

    def setup(db)
      db.exec "drop table if exists posts"

      db.exec "create table posts (key text, title text, body text)"
      db.exec "insert into posts values (?, ?, ?)", "hello-world", "Hello world", "I am the first post. Isn't it amazing?"
    end

    def open
      DB.open "sqlite3://./data.db"
    end

    def close(db)
      db.close
    end
  end
end
