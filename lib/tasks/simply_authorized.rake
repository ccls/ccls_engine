#	From `script/generate simply_authorized` ...
unless Gem.source_index.find_name('jakewendt-simply_authorized').empty?
	gem 'jakewendt-simply_authorized'
	require 'simply_authorized/test_tasks'
end
