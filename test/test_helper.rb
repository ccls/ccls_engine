ENV["RAILS_ENV"] = "test"
require 'test/unit'			#	NEED THIS OR THE TESTS DON'T ACTUALLY EXECUTE
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'action_controller'
require 'action_mailer'

#require File.dirname(__FILE__) + '/../rails/init.rb' 

#	http://guides.rubyonrails.org/plugins.html

#require File.dirname(__FILE__) + '/config/boot'
require File.dirname(__FILE__) + '/config/environment'
require 'test_help'

require 'factories'


def setup_db
	ActiveRecord::Migrator.migrate("db/migrate/",nil)
end

def teardown_db
	ActiveRecord::Migrator.migrate("db/migrate/",0)
end

setup_db()
