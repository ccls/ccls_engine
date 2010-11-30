#
#	If the gem doesn't exist then this would block
#	the usage of rake gems:install
#	If we wrap it in this condition, it works fine.
#
if Gem.searcher.find('paperclip')
	require 'paperclip'
	load "tasks/paperclip.rake"
end

if Gem.searcher.find('simply_helpful')
	require 'simply_helpful/tasks'
end


#
#	By using separate migration directories, we can separate
#	those needed just for testing and those needed in production.
#
#	Unfortunately, this does not yet facilitate up and down
#	as these migration numbers get "lost"
#

namespace :db do
	namespace :migrate do
		task :dev_only => :environment do
			ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
			ActiveRecord::Migrator.migrate("test/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
		end
	end
end
Rake::Task['db:migrate'].prerequisites.unshift(
	"db:migrate:dev_only" ) if Rails.env == 'development'
