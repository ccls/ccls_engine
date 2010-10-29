class CclsEngineGenerator < Rails::Generator::Base

	def manifest
		#	See Rails::Generator::Commands::Create
		#	rails-2.3.10/lib/rails_generator/commands.rb
		#	for code methods for record (Manifest)
		record do |m|

			File.open('Rakefile','a'){|f|
				f.puts <<-EOF
# From `script/generate ccls_engine` ...
require 'ccls_engine/test_tasks'
				EOF
			}
			File.open('.autotest','a'){|f| 
				f.puts <<-EOF
# From `script/generate ccls_engine` ...
require 'ccls_engine/autotest'
				EOF
			}

			%w( create_users create_user_invitations ).each do |migration|
				m.migration_template "migrations/#{migration}.rb",
					'db/migrate', :migration_file_name => migration
			end

			m.directory('public/javascripts')
			Dir["#{File.dirname(__FILE__)}/templates/javascripts/*js"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "public/javascripts/#{File.basename(file)}")
			}
			m.directory('public/stylesheets')
			Dir["#{File.dirname(__FILE__)}/templates/stylesheets/*css"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "public/stylesheets/#{File.basename(file)}")
			}
#			m.directory('test/functional/ccls')
#			Dir["#{File.dirname(__FILE__)}/templates/functional/*rb"].each{|file| 
#				f = file.split('/').slice(-2,2).join('/')
#				m.file(f, "test/functional/ccls/#{File.basename(file)}")
#			}
#			m.directory('test/unit/ccls')
#			Dir["#{File.dirname(__FILE__)}/templates/unit/*rb"].each{|file| 
#				f = file.split('/').slice(-2,2).join('/')
#				m.file(f, "test/unit/ccls/#{File.basename(file)}")
#			}
		end
	end

end
module Rails::Generator::Commands
	class Create
		def migration_template(relative_source, 
				relative_destination, template_options = {})
			migration_directory relative_destination
			migration_file_name = template_options[
				:migration_file_name] || file_name
			if migration_exists?(migration_file_name)
				puts "Another migration is already named #{migration_file_name}: #{existing_migrations(migration_file_name).first}: Skipping" 
			else
				template(relative_source, "#{relative_destination}/#{next_migration_string}_#{migration_file_name}.rb", template_options)
			end
		end
	end #	Create
	class Base
	protected
		#	the loop through migrations happens so fast
		#	that they all have the same timestamp which
		#	won't work when you actually try to migrate.
		#	All the timestamps MUST be unique.
		def next_migration_string(padding = 3)
			@s = (!@s.nil?)? @s.to_i + 1 : if ActiveRecord::Base.timestamped_migrations
				Time.now.utc.strftime("%Y%m%d%H%M%S")
			else
				"%.#{padding}d" % next_migration_number
			end
		end
	end	#	Base
end
