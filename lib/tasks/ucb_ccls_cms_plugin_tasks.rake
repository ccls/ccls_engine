# desc "Explaining what the task does"
# task :ucb_ccls_cms_plugin do
#   # Task goes here
# end

namespace :cms do
	desc "Sync extra files from CMS plugin engine."
	task :sync do
		system "rsync -ruv vendor/plugins/ucb_ccls_cms_engine/db/migrate db"
		system "rsync -ruv vendor/plugins/ucb_ccls_cms_engine/public ."
	end
end
