require "sqlite3"

class Migrator
  def initialize(@url : String)
  end

  def run_pending_migrations!
    setup_migration_table

    migrate "initial-setup" do |db|
      db.exec "create table posts (id int primary key, key text, title text, body text);"
      db.exec "insert into posts values (1, \"hello-world\", \"Hello world\", \"I am the first post. Isn't it amazing?\");"
    end
  end

  private def migrate(name, &blk)
    if run_migration?(name)
      puts "Running migration: #{name}"

      DB.open @url do |db|
        db.transaction do |tx|
          # execute given migration commands
          yield(tx.connection)

          # add this migration to the internal migrations list
          tx.connection.exec "INSERT INTO _migrations VALUES (?)", name
        end
      end
    end
  end

  private def run_migration?(name)
    DB.open @url do |db|
      v = db.scalar "SELECT COUNT(name) FROM _migrations WHERE name = ?", name
      v == 0
    end
  end

  private def setup_migration_table
    DB.open @url do |db|
      db.exec "CREATE TABLE IF NOT EXISTS _migrations (name TEXT)"
    end
  end
end
