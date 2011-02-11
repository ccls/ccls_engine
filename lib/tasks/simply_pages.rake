#	From `script/generate simply_pages` ...
unless Gem.source_index.find_name('jakewendt-simply_pages').empty?
	gem 'jakewendt-simply_pages'
	require 'simply_pages/test_tasks'
end
