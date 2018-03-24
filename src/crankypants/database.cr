require "sqlite3"
require "crecto"

module Crankypants
  module Repo
    extend Crecto::Repo

    config do |conf|
      conf.adapter = Crecto::Adapters::SQLite3
      conf.database = "./data.db"
    end
  end
end
