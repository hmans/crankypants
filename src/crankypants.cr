require "habitat"
require "./crankypants/migrator"

module Crankypants
  Habitat.create do
    setting database_uri : String
    setting port : Int32
    setting interface : String
    setting asset_host : String
  end

  def self.prepare_database
    # make sure data directory exists
    Dir.mkdir_p "./data"

    # Create and/or migrate our database to the latest
    # schema version.
    #
    Migrator.execute(url: Crankypants.settings.database_uri) do |m|
      m.migrate "initial-setup" do |db|
        db.exec "create table posts (id integer primary key, key text, title text, body text, body_html text, created_at, updated_at);"
      end
    end
  end
end

Crankypants.configure do
  settings.database_uri = "sqlite3://./data/crankypants.db"
  settings.port = 3000
  settings.interface = "0.0.0.0"
  settings.asset_host = ""
end
