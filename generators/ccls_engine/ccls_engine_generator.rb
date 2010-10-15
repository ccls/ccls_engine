class CclsEngineGenerator < Rails::Generator::NamedBase

#		def initialize(runtime_args, runtime_options = {})
#	puts "In initialize"
#	#		#	Rails::Generator::NamedBase apparently requires
#	#		#	at least 1 argumnet.  The first will be used
#	#		#	for things like migration class name
#	#		runtime_args.unshift 'CreateTracksTable'
#			super
#		end

	def manifest
		record do |m|
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
