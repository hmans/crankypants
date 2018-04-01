require "./crankypants/*"

module Crankypants
end

# Create and/or migrate our database to the latest
# schema version.
#
Migrator.execute(url: "sqlite3://./data.db") do |m|
  m.migrate "initial-setup" do |db|
    db.exec "create table posts (id integer primary key, key text, title text, body text, created_at, updated_at);"
  end
end

# Run our web app.
#
Crankypants::Web.run
