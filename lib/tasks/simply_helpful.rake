#	From `script/generate simply_helpful` ...
#if Gem.searcher.find('simply_helpful')
unless Gem.source_index.find_name('jakewendt-simply_helpful').empty?
	require 'simply_helpful/tasks'
	require 'simply_helpful/test_tasks'
end
