#class CclsEngineGenerator < Rails::Generator::NamedBase
#	Using NamedBase required a user model parameter like so ...
#	script/generate ccls_engine User
#	which created a variable called "class_name" available to the templates.
#	As it is no longer used, changing to just Base so it can be used like so ...
#	script/generate ccls_engine
class CclsEngineGenerator < Rails::Generator::Base

	def manifest
		#	See Rails::Generator::Commands::Create
		#	rails-2.3.10/lib/rails_generator/commands.rb
		#	for code methods for record (Manifest)
		record do |m|

			#	The autotest file will require that the app actually 
			#		looks for autotest files.
			m.directory('config/autotest')
			m.file('autotest_ccls_engine.rb', 'config/autotest/ccls_engine.rb')

			#	*.rake files in the lib/tasks/ directory are automatically
			#		loaded so nothing is required to include this.
			m.directory('lib/tasks')
			m.file('ccls_engine.rake', 'lib/tasks/ccls_engine.rake')

#	no longer seems to be needed, but keeping for now
#	until included calnet_authentication
#	it is entirely commented out now so
#			m.directory('config/initializers')
#			m.template('initializer.rb', 'config/initializers/ccls_engine.rb')

#			%w( create_users create_user_invitations ).each do |migration|
#	UserInvitations are NOT used for any app which uses the ccls engine.
			%w( create_users create_user_invitations drop_user_invitations ).each do |migration|
				m.migration_template "migrations/#{migration}.rb",
					'db/migrate', :migration_file_name => migration
			end

			dot = File.dirname(__FILE__)

			m.directory('public/images')
			Dir["#{dot}/templates/images/*"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "public/images/#{File.basename(file)}")
			}
			m.directory('public/javascripts')
			Dir["#{dot}/templates/javascripts/*js"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "public/javascripts/#{File.basename(file)}")
			}
			m.directory('public/stylesheets')
			Dir["#{dot}/templates/stylesheets/*css"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "public/stylesheets/#{File.basename(file)}")
			}

			Dir["#{dot}/templates/views/*/**/"].each do |dir|
				last_dir = dir.split('/').last
				m.directory("app/views/#{last_dir}")
				Dir["#{dot}/templates/views/#{last_dir}/*rb"].each do |file|
					f = file.split('/').slice(-3,3).join('/')
					m.file(f, "app/views/#{last_dir}/#{File.basename(file)}")
				end
			end

			m.directory('app/controllers')
			Dir["#{dot}/templates/controllers/*rb"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "app/controllers/#{File.basename(file)}")
			}
			m.directory('test/functional/ccls')
			Dir["#{dot}/templates/functional/*rb"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "test/functional/ccls/#{File.basename(file)}")
			}

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
