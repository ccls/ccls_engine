#	condition added to allow clean 'rake gems:install'
if Gem.searcher.find('ccls_engine')
	require 'ccls_engine/tasks'
	#	From `script/generate ccls_engine` ...
	require 'ccls_engine/test_tasks'
end
