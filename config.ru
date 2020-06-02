$:.unshift File.dirname(__FILE__)

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pry'
require 'bookfilm/api'

use Rack::Reloader, 0
use Rack::ContentLength

run Bookfilm::API
