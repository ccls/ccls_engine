namespace :db do

	desc "Create yml fixtures for given model in database\n" <<
	     "rake db:extract_fixtures_from pages"
	task :extract_fixtures_from => :environment do
		me = $*.shift
		while( table_name = $*.shift )
			File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|
				data = table_name.singularize.capitalize.constantize.find(
					:all).collect(&:attributes)
				file.write data.inject({}) { |hash, record|
					record.delete('created_at')
					record.delete('updated_at')
					hash["#{table_name}_#{record['id']}"] = record
					hash
				}.to_yaml
			end
		end
		exit
	end

end
