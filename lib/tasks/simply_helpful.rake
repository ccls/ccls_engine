#	From `script/generate simply_helpful` ...
unless Gem.source_index.find_name('jakewendt-simply_helpful').empty?
	gem 'jakewendt-simply_helpful'
	require 'simply_helpful/tasks'
	require 'simply_helpful/test_tasks'
end
