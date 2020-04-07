# frozen_string_literal: true

require 'db/connection'
DB_CONNECTION = DB::Connection.connection

begin
  require 'bookfilm/film'
rescue Sequel::DatabaseError => e
  puts "Could not initialize models: #{e}"
end
