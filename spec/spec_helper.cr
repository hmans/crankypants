require "spec"
require "../src/crankypants"
require "../src/crankypants/repo"

Crankypants.configure do
  settings.database_uri = "sqlite3://./data/test.db"
end

Crankypants.prepare_database

# Let's learn from the best (ie. Rails) and wrap every single
# spec inside a transaction that we ultimately roll back.
#
Spec.before_each do
  Crankypants::Repo.config.get_connection.exec "BEGIN"
end

Spec.after_each do
  Crankypants::Repo.config.get_connection.exec "ROLLBACK"
end

at_exit do
  File.delete "./data/test.db"
end
