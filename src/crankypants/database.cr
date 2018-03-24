require "sqlite3"
require "crecto"
require "micrate"

# Micrate::DB.connection_url = "sqlite://./data.db"
# Micrate.up
#
module Crankypants
  module Repo
    extend Crecto::Repo

    config do |conf|
      conf.adapter = Crecto::Adapters::SQLite3
      conf.database = "./data.db"
    end
  end
end
