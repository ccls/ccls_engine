#	This file is here so that the plugin/engine can
#	run standard rails rake tasks.
require File.join(File.dirname(__FILE__), 'boot')
Rails::Initializer.run do |config|
end
