namespace :ccls do
	desc "Sync extra files from CCLS engine."
	task :sync do
		system "rsync -ruv vendor/plugins/ucb_ccls_engine/db/migrate db"
		system "rsync -ruv vendor/plugins/ucb_ccls_engine/public ."
	end
end

#
#	If the gem doesn't exist then this would block
#	the usage of rake gems:install
#	If we wrap it in this condition, it works fine.
#
if Gem.searcher.find('paperclip')
	require 'paperclip'
	load "tasks/paperclip.rake"
end
