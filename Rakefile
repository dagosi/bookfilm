lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pry'
require 'db/connection'
DB_CONNECTION = DB::Connection.connection

namespace :db do
  desc "Create a new DB, and drops the previous one if it exists"
  task :create do
    DB.create!
  end

  task :migrate do
    DB.migrate
  end

  task :reset do
    DB.reset!
  end
end
