namespace :app do

#	task :args_as_array do
#		args = $*.dup.slice(1..-1)
#		puts args.collect {|arg| "X:" << arg }.join("\n")
#		exit
#	end

	desc "Load some fixtures to database for application"
	task :update => :environment do
#			gift_cards
		fixtures = %w(
			address_types
			data_sources
			diagnoses
			document_types
			document_versions
			hospitals
			ineligible_reasons
			instrument_versions
			instruments
			interview_methods
			interview_outcomes
			instrument_types
			languages
			organizations
			operational_event_types
			people
			phone_types
			projects
			races
			refusal_reasons
			roles
			sample_outcomes
			sample_types
			states
			subject_relationships
			subject_types
			units
			vital_statuses 
		)
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
		Rake::Task["db:fixtures:load"].reenable

		#	the zip_codes.csv fixtures is too big and takes too long to
		#	load in testing, so I left a small one there and put
		#	the full version from http://www.populardata.com/zipcode_database.html
		fixtures = %w(
			zip_codes
		)
		ENV['FIXTURES'] = fixtures.join(',')
		ENV['FIXTURES_PATH'] = 'production/fixtures'
		puts "Loading production fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
	end

	desc "Add some expected users."
	task :add_users => :environment do
		puts "Adding users"
		%w( 859908 228181 214766 180918 66458 808 768475 
			10883 86094 754783 769067 854720 16647 ).each do |uid|
			puts " - Adding user with uid:#{uid}:"
			User.find_create_and_update_by_uid(uid)
		end
	end

	desc "Deputize user by UID"
	task :deputize => :environment do
		puts
		if ENV['uid'].blank?
			puts "User's CalNet UID required."
			puts "Usage: rake #{$*} uid=INTEGER"
			puts
			exit
		end
		if !User.exists?(:uid => ENV['uid'])
			puts "No user found with uid=#{ENV['uid']}."
			puts
			exit
		end
		user = User.find(:first, :conditions => { :uid => ENV['uid'] })
		puts "Found user #{user.displayname}.  Deputizing..."
		user.deputize
		puts "User deputized: #{user.is_administrator?}"
		puts
	end

end
