#	From `script/generate simply_authorized` ...
#if Gem.searcher.find('simply_authorized')
unless Gem.source_index.find_name('jakewendt-simply_authorized').empty?
require 'simply_authorized/test_tasks'
end
