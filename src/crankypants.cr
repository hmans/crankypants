require "./crankypants/*"

module Crankypants
end

# Create and/or migrate our database to the latest
# schema version.
#
Migrator.new(url: "sqlite3://./data.db").run_pending_migrations!

# Run our web app.
#
Crankypants::Web.run
