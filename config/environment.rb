# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DrtsRuby::Application.initialize!

Rails.configuration.game = {:maxZoom => 3, :defaultZoom => 0, :borderCache => 0, :tileSize => 256}
