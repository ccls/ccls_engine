namespace :ccls do
	desc "Sync extra files from CCLS engine."
	task :sync do
		system "rsync -ruv vendor/plugins/ucb_ccls_engine/db/migrate db"
		system "rsync -ruv vendor/plugins/ucb_ccls_engine/public ."
	end
end
