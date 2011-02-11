unless Gem.source_index.find_name('jakewendt-use_db').empty?
	gem 'jakewendt-use_db'
	require 'use_db/tasks'
end
