#class CclsEngineGenerator < Rails::Generator::NamedBase
class CclsEngineGenerator < Rails::Generator::Base

#		def initialize(runtime_args, runtime_options = {})
#	puts "In initialize"
#	#		#	Rails::Generator::NamedBase apparently requires
#	#		#	at least 1 argumnet.  The first will be used
#	#		#	for things like migration class name
#			runtime_args.unshift 'CCLSEngine'
#			super
#		end

	def manifest
		#	See Rails::Generator::Commands::Create
		#	rails-2.3.10/lib/rails_generator/commands.rb
		#	for code methods for record (Manifest)
		record do |m|
			m.directory('test/unit/ccls')
			Dir["#{File.dirname(__FILE__)}/templates/unit/*rb"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "test/unit/ccls/#{File.basename(file)}")
			}
			m.directory('test/functional/ccls')
			Dir["#{File.dirname(__FILE__)}/templates/functional/*rb"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "test/functional/ccls/#{File.basename(file)}")
			}

#			m.file('unit_tests', 'test/unit/ccls/ccls')
#			m.file('application.css', 'public/stylesheets/application.css')
#			m.migration_template 'migration.rb', 'db/migrate', 
#				:migration_file_name => "add_calnet_authenticated_columns_to_#{file_path.gsub(/\//, '_').pluralize}"
		end
	end

#	I have no idea what I'm doing.  Monkey see, monkey do.
#	This does seem to work though.
#	class_name = the first argument passed to the generator
#	file_path  = class_name.underscore
#		tableize would have been good
#	AddTrackingNumberTo
#				:assigns => { :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}" }, 
#	
#	where does "file_path" come from?

end
