#	From `script/generate simply_trackable` ...
unless Gem.source_index.find_name('jakewendt-simply_trackable').empty?
	gem 'jakewendt-simply_trackable'
	#require 'simply_trackable'
	require 'simply_trackable/test_tasks'
end
