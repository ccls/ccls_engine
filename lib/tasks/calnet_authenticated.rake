#	From `script/generate calnet_authenticated` ...
#if Gem.searcher.find('calnet_authenticated')
unless Gem.source_index.find_name('ccls-calnet_authenticated').empty?
require 'calnet_authenticated/test_tasks'
end
