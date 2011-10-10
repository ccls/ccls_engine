#       From `script/generate simply_authorized` ...
#if sa_gem = Gem.source_index.find_name('ccls-simply_authorized').last
#	gem 'ccls-simply_authorized'
#	require 'simply_authorized'
#	#	it sucks, but this is needed for rake due to the configuration
#	require sa_gem.full_gem_path + '/app/models/role'
#	require 'simply_authorized/test_tasks'
#end
unless Gem.source_index.find_name('ccls-simply_authorized').empty?
	gem 'ccls-simply_authorized'
	require 'simply_authorized/test_tasks'
end
