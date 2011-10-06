unless Gem.source_index.find_name('ccls-use_db').empty?
	gem 'ccls-use_db'
	require 'use_db/tasks'
end
