require 'active_record'
require 'use_db'

#module UseDbTestExtension
#	def self.included(base)
#		unless base.methods.include?('my_other_databases') 
#			base.extend(ClassMethods)
#			base.class_eval do
#				class << self
#					alias :other_databases :my_other_databases
#				end
#			end
#		end
#	end
#	module ClassMethods
#		#	In preparation for keeping the use_db.yml DRY and in the gem
#		def my_other_databases
##		def other_databases
#			YAML.load(
#				File.read( 
#					File.join(
#						File.dirname(__FILE__),'..','..','config','shared_use_db.yml'
#			))).values.collect(&:symbolize_keys!)
#		end
#	end
#end
#UseDbTest.send(:include,UseDbTestExtension)

#module UseDbPluginExtension
#	def self.included(base)
#		unless base.methods.include?('get_use_db_conn_spec_without_ccls_read')
#			base.send(:include,ModuleMethods)
#			base.alias_method_chain :get_use_db_conn_spec, :ccls_read
#		end
#	end
#	module ModuleMethods
#		def get_use_db_conn_spec_with_ccls_read(options)
#			if ActiveRecord::Base.configurations.empty?
#				#	for rake tasks
#				ActiveRecord::Base.configurations.update(YAML::load(ERB.new(IO.read(
#					File.join( Rails.root,'config','database.yml'))).result))
#			end
#			ActiveRecord::Base.configurations.update(YAML::load(ERB.new(IO.read(
#				File.join( Rails.root,'config','shared_database.yml'))).result))
#			get_use_db_conn_spec_without_ccls_read(options)
#		end
#	end
#end
#UseDbPlugin.send(:include,UseDbPluginExtension)

USE_DB_CONFIG  =  File.join( Rails.root,'config','shared_use_db.yml')
OTHER_DB_FILES = [File.join( Rails.root,'config','shared_database.yml')]

class ActiveSupport::TestCase
	unless defined?(CLONED_DB_FOR_CCLS_TEST)
		UseDbTest.prepare_test_db(:prefix => "shared_")
		CLONED_DB_FOR_CCLS_TEST = true
	end
end if Rails.env == 'test'
