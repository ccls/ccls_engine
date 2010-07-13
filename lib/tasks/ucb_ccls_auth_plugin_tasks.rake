# desc "Explaining what the task does"
# task :ucb_ccls_auth_plugin do
#   # Task goes here
# end

namespace :auth do
	desc "Sync extra files from Auth plugin engine."
	task :sync do
		system "rsync -ruv vendor/plugins/ucb_ccls_auth_engine/db/migrate db"
		system "rsync -ruv vendor/plugins/ucb_ccls_auth_engine/public ."
	end
end
