require 'active_record'
require 'use_db'

shared_db_file = File.join( Rails.root,'config','shared_database.yml')
if File.exists?(shared_db_file)
	puts "Loading shared database mods." 
	USE_DB_CONFIG  = File.join(File.dirname(__FILE__),'..','..','config','shared_use_db.yml')
	OTHER_DB_FILES = [shared_db_file]

	class ActiveSupport::TestCase
		unless defined?(CLONED_DB_FOR_CCLS_TEST)
			UseDbTest.prepare_test_db
			UseDbTest.prepare_test_db(:prefix => "shared_")
			CLONED_DB_FOR_CCLS_TEST = true
		end
	end if Rails.env == 'test'
else
	puts "*\n* Expected, but didn't find, #{shared_db_file}"
	puts "* Probably gonna crash now.\n*"
end
