#	From `script/generate simply_helpful` ...
unless Gem.source_index.find_name('ccls-simply_helpful').empty?
	gem 'ccls-simply_helpful'
	require 'simply_helpful/tasks'
	require 'simply_helpful/test_tasks'
end
