#	This file is here so that the plugin/engine can
#	run standard rails rake tasks.
require File.join(File.dirname(__FILE__), 'boot')
Rails::Initializer.run do |config|
#	Trying to make engine routes play nice with app routes.
#	Not going so well.
#	config.routes_configuration_file = File.expand_path(
#		File.join(File.dirname(__FILE__),'engine_routes.rb'))
end
