require './lib/datascope.rb'
require 'rack/coffee'

use Rack::Coffee

run Datascope

