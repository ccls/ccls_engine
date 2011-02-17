unless Gem.source_index.find_name('paperclip').empty?
	require 'paperclip'
	load "tasks/paperclip.rake"
end
