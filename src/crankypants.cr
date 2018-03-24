require "./crankypants/*"
require "micrate"

module Crankypants
end

# Run pending database migrations
Micrate::DB.connection_url = "sqlite3://./data.db"
Micrate::Cli.run_up

# Run web app
Crankypants::Web.run
