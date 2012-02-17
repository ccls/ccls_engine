namespace :ccls do

	desc "Dump data to xml files"
	task :export_to_xml => :environment do
		outdir = if Rails.env == 'production'
			"/my/ruby/xml"
		else
			"."
		end
#		%w( project enrollment study_subject pii identifier
		%w( project enrollment study_subject 
				patient phone_number address addressing ).each do |model|
			puts "Exporting #{model.pluralize} ..."
			File.open("#{outdir}/#{model.pluralize}.xml",'w'){|f| 
				f.puts model.camelize.constantize.all.to_xml }
		end
	end

	desc "Report data counts in database"
	task :data_report => :environment do

		printf "%-25s %5d\n", "StudySubject.count:", StudySubject.count

		StudySubject.all(:select => "subject_type_id, COUNT(*) AS count",
				:group => :subject_type_id ).each do |e|
			printf "%-25s %5d\n", "subject_type = #{e.subject_type}:", e.count
		end

		%w{ case_control_type childidwho }.each do |field|
			StudySubject.all(:select => "#{field}, COUNT(*) AS count",
					:group => field ).each do |e|
				printf "%-25s %5d\n", "#{field} = #{e.send(field)}:", e.count
			end
		end

		printf "%-25s %5d\n", "Patient.count:", Patient.count
		%w{ was_under_15_at_dx was_previously_treated was_ca_resident_at_diagnosis 
		}.each do |field|
			Patient.all(:select => "#{field}, COUNT(*) AS count",
					:group => field ).each do |e|
				printf "%-25s %5d\n", "#{field} = #{e.send(field)}:", e.count
			end
		end

		printf "%-25s %5d\n", "Enrollment.count:", Enrollment.count
		printf "%-25s %5d\n", "OperationalEvent.count:", OperationalEvent.count

		printf "%-25s %5d\n", "CCLS Enrollments.count:", Enrollment.count(
			:conditions => { :project_id => Project['ccls'].id })
		%w{ consented is_eligible refusal_reason_id document_version_id
		}.each do |field|
			Enrollment.all(:select => "#{field}, COUNT(*) AS count",
					:conditions => { :project_id => Project['ccls'].id },
					:group      => field ).each do |e|
				printf "%-25s %5d\n", "#{field} = #{e.send(field)}:", e.count
			end
		end

		printf "%-25s %5d\n", "IcfMasterId.count:", IcfMasterId.count
		printf "%-25s %5d\n", "Used IcfMasterId.count:", IcfMasterId.count(
			:conditions => [ 'study_subject_id IS NOT NULL' ])
		printf "%-25s %5d\n", "Unused IcfMasterId.count:", IcfMasterId.count(
			:conditions => [ 'study_subject_id IS NULL' ])

	end

#	task :sync_subject_type => :environment do
#		abort("Don't do this in production! Not unless you know exactly what you're doing anyway."
#			) if Rails.env == 'production'
#		Identifier.find(:all).each_with_index do |identifier,index|
#			puts "Processing #{index}"
#			study_subject = identifier.study_subject
#			if study_subject.nil?
#				puts "No study_subject on this identifier" 
#				next
#			end
#			puts "case_control_type #{identifier.case_control_type}"
#			puts "subject_type #{study_subject.subject_type}"
#			if study_subject.subject_type.to_s == 'Case' and identifier.case_control_type != 'C'
#				puts "subject_type == 'Case' and case_control_type != 'C'"
#				study_subject.patient.destroy unless study_subject.patient.nil?
#				study_subject.reload.subject_type = SubjectType['Control']
#				study_subject.save!
#				puts "NEW subject_type #{study_subject.reload.subject_type}"
#			end
#		end
#	end

	desc "Load some fixtures to database for application"
	task :update => :environment do
#			gift_cards
		fixtures = %w(
			address_types
			contexts
			context_data_sources
			data_sources
			diagnoses
			document_types
			document_versions
			follow_up_types
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
			sections
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
	end

	task :full_update => :update do
#
#	We don't use this yet, plus it hasn't changed, so why keep updating it?
#	It takes about 30 minutes.
#
#		#	the zip_codes.csv fixtures is too big and takes too long to
#		#	load in testing, so I left a small one there and put
#		#	the full version from http://www.populardata.com/zipcode_database.html
		fixtures = %w(
			zip_codes
			counties
		)
#	Do not import icf_master_ids this way in production as these are real
#	icf_master_ids and some may be assigned to real subjects already.
#			icf_master_ids
		ENV['FIXTURES'] = fixtures.join(',')
		ENV['FIXTURES_PATH'] = 'production/fixtures'
		puts "Loading production fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
		Rake::Task["db:fixtures:load"].reenable
	end

	desc "Add some expected users."
	task :add_users => :environment do
		puts "Adding users"
		%w( 859908 228181 214766 180918 66458 768475 
			10883 86094 769067 ).each do |uid|
			puts " - Adding user with uid:#{uid}:"
			User.find_create_and_update_by_uid(uid)
		end
	end

	desc "Add user by UID"
	task :add_user => :environment do
		puts
		if ENV['uid'].blank?
			puts "User's CalNet UID required."
			puts "Usage: rake #{$*} uid=INTEGER"
			puts
			exit
		end
		if !User.exists?(:uid => ENV['uid'])
			puts "No user found with uid=#{ENV['uid']}. Adding..."
			User.find_create_and_update_by_uid(ENV['uid'])
		else
			puts "User with uid #{ENV['uid']} already exists."
		end
		puts
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


__END__

#	task :args_as_array do
#		args = $*.dup.slice(1..-1)
#		puts args.collect {|arg| "X:" << arg }.join("\n")
#		exit
#	end


Another way to pass arguments to rake task as demonstrated by one of the sunspot gem's tasks
...
  # This task depends on the standard Rails file naming \
  # conventions, in that the file name matches the defined class name. \
  # By default the indexing system works in batches of 50 records, you can \
  # set your own value for this by using the batch_size argument. You can \
  # also optionally define a list of models to separated by a forward slash '/'
  # 
  # $ rake sunspot:reindex                # reindex all models
  # $ rake sunspot:reindex[1000]          # reindex in batches of 1000
  # $ rake sunspot:reindex[false]         # reindex without batching
  # $ rake sunspot:reindex[,Post]         # reindex only the Post model
  # $ rake sunspot:reindex[1000,Post]     # reindex only the Post model in
  #                                       # batchs of 1000
  # $ rake sunspot:reindex[,Post+Author]  # reindex Post and Author model
  task :reindex, :batch_size, :models, :needs => :environment do |t, args|
    reindex_options = {:batch_commit => false}
    case args[:batch_size]
    when 'false'
      reindex_options[:batch_size] = nil
    when /^\d+$/ 
      reindex_options[:batch_size] = args[:batch_size].to_i if args[:batch_size].to_i > 0
    end
    unless args[:models]
      all_files = Dir.glob(Rails.root.join('app', 'models', '*.rb'))
      all_models = all_files.map { |path| File.basename(path, '.rb').camelize.constantize }
      sunspot_models = all_models.select { |m| m < ActiveRecord::Base and m.searchable? }
    else
      sunspot_models = args[:models].split('+').map{|m| m.constantize}
    end
    sunspot_models.each do |model|
      model.solr_reindex reindex_options
    end
  end

