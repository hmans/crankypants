module Migrator
  extend self

  def migrate!(url : String)
    puts "Migrating #{url}"

    DB.open(url) do |db|
    end
  end
end
