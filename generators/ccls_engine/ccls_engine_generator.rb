class CclsEngineGenerator < Rails::Generator::Base

	def manifest
		#	See Rails::Generator::Commands::Create
		#	rails-2.3.10/lib/rails_generator/commands.rb
		#	for code methods for record (Manifest)
		record do |m|

			%w( create_users create_pages create_user_invitations
				create_roles create_roles_users create_photos
				add_attachments_image_to_photo create_documents
				add_attachments_document_to_document ).each do |migration|
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
			m.directory('test/functional/ccls')
			Dir["#{File.dirname(__FILE__)}/templates/functional/*rb"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "test/functional/ccls/#{File.basename(file)}")
			}

		end
	end

end
class Rails::Generator::Commands::Base
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
end
