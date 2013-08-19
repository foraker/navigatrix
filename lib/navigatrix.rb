require "navigatrix/version"
require "navigatrix/item"
require "navigatrix/item_collection"
require "navigatrix/renderer"
require 'navigatrix/integration/rails' if defined?(Rails)
require 'navigatrix/integration/sinatra' if defined?(Sinatra)

module Navigatrix
end
