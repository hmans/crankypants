require "sqlite3"
require "colorize"

class Migrator
  def initialize(@url : String)
  end

  def execute(&blk : Migrator -> _)
    setup_migration_table
    blk.call(self)
  end

  def self.execute(url : String, &blk : Migrator -> _)
    new(url).execute(&blk)
  end

  def migrate(name)
    if run_migration?(name)
      say "Running migration: #{name}"

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

  private def say(text)
    puts [" * ".colorize(:green), text.colorize(:white)].join
  end
end
