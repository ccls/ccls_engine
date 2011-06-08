ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase

	fixtures :all

end

class ActionController::TestCase

	setup :turn_https_on

	def self.site_administrators
		@site_administrators ||= %w( superuser administrator )
	end

	def self.non_site_administrators
		@non_site_administrators ||= ( all_test_roles - site_administrators )
	end

	def self.site_editors
		@site_editors ||= %w( superuser administrator editor )
	end

	def self.non_site_editors
		@non_site_editors ||= ( all_test_roles - site_editors )
	end

	def self.site_readers
		@site_readers ||= %w( superuser administrator editor interviewer reader )
	end

	def self.non_site_readers
		@non_site_readers ||= ( all_test_roles - site_readers )
	end

	def self.all_test_roles
		@all_test_roles = %w( superuser administrator editor interviewer reader active_user )
	end

end
