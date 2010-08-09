namespace :ccls do
	desc "Sync extra files from CCLS engine."
	task :sync do

#	How to make this work ONLY for apps and not self/plugin/engine.

		FileUtils.mkdir_p('db/migrate') unless File.directory?('db/migrate')
		system "rsync -ruv vendor/plugins/ucb_ccls_engine/db/migrate db"
		FileUtils.mkdir_p('public') unless File.directory?('public')
#		system "rsync -ruv vendor/plugins/ucb_ccls_engine/public/ public/"
		system "rsync -ruv vendor/plugins/ucb_ccls_engine/public ."

		rsync_command = <<-EOF.gsub(/\s+/,' ').squish!
			rsync -ruv 
			--exclude='app'
			--exclude='assets'
			--exclude='config'
			--exclude='db'
			--exclude='extensions'
			--exclude='fixtures'
			--exclude='helpers'
			--exclude='log'
			--exclude='versions'
			--exclude='test_helper.rb'
			--exclude='engine_\*_test.rb'
			vendor/plugins/ucb_ccls_engine/test .
		EOF
		system rsync_command
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
