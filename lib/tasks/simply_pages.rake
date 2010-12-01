#	From `script/generate simply_pages` ...
#if Gem.searcher.find('simply_pages')
unless Gem.source_index.find_name('jakewendt-simply_pages').empty?
require 'simply_pages/test_tasks'
end
