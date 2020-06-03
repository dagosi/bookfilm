# frozen_string_literal: true

require 'db/connection'
DB_CONNECTION = DB::Connection.connection

require 'bookfilm/api'

require 'bookfilm/models/app_model'
require 'bookfilm/models/film'
require 'bookfilm/models/booking'

require 'bookfilm/services/create_booking'
require 'bookfilm/services/create_film'
