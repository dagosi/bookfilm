# frozen_string_literal: true

require 'db/connection'
DB_CONNECTION = DB::Connection.connection

require 'bookfilm/api'
require 'bookfilm/models/film'
require 'bookfilm/services/create_booking'
