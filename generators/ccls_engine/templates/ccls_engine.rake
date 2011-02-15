#	condition added to allow clean 'rake gems:install'
unless Gem.source_index.find_name('ccls-ccls_engine').empty?
	gem 'ccls-ccls_engine'

	RAILS_DEFAULT_LOGGER = nil unless defined? RAILS_DEFAULT_LOGGER
	#	gems/rubycas-client-2.2.1/lib/casclient/frameworks/rails/filter.rb:141:in `configure'
	#	gems/jakewendt-calnet_authenticated-0.4.1/lib/calnet_authenticated/controller.rb:18:in `included'

# jakewendt@dev : homex 1104> rake gems:install RAILS_ENV=test --trace                           (in /Users/jakewendt/github_repo/ccls/homex)
#	Loading shared database mods.
#	rake aborted!
#	uninitialized class variable @@configuration in Rails
#	/Library/Ruby/Gems/1.8/gems/rails-2.3.11/lib/initializer.rb:20:in `configuration'
#	/Library/Ruby/Gems/1.8/gems/thoughtbot-factory_girl-1.2.2/lib/factory_girl.rb:24
#	/Library/Ruby/Site/1.8/rubygems/custom_require.rb:29:in `gem_original_require'
#	/Library/Ruby/Site/1.8/rubygems/custom_require.rb:29:in `require'
#	
#	Don't do this ...
#		require 'ccls_engine'

	require 'ccls_engine/tasks'
	#	From `script/generate ccls_engine` ...
	require 'ccls_engine/test_tasks'
end
