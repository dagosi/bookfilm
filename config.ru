$:.unshift File.dirname(__FILE__)
require 'routing'

use Rack::Reloader, 0
use Rack::ContentLength

run Routing
