# From `script/generate ccls_engine` ...
# condition added to allow clean 'rake gems:install'
unless Gem.source_index.find_name('ccls-ccls_engine').empty?
	gem 'ccls-ccls_engine'

	RAILS_DEFAULT_LOGGER = nil unless defined? RAILS_DEFAULT_LOGGER
	#	gems/rubycas-client-2.2.1/lib/casclient/frameworks/rails/filter.rb:141:in `configure'
	#	gems/ccls-calnet_authenticated-0.4.1/lib/calnet_authenticated/controller.rb:18:in `included'
	require 'ccls_engine'
	require 'ccls_engine/tasks'
	require 'ccls_engine/test_tasks'
end
