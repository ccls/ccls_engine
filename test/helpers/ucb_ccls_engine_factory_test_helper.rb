module UcbCclsEngineFactoryTestHelper

	def active_user(options={})
		u = Factory(:user, options)
		#	leave this special save here just in case I change things.
		#	although this would need changed for UCB CAS.
		#	u.save_without_session_maintenance
		#	u
	end
	alias_method :user, :active_user

	def superuser(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('superuser')
		u
	end
	alias_method :super_user, :superuser

	def admin_user(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('administrator')
		u
	end
	alias_method :admin, :admin_user
	alias_method :administrator, :admin_user

	def interviewer(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('interviewer')
		u
	end

	def reader(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('reader')
		u
	end
#	alias_method :employee, :reader

	def editor(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('editor')
		u
	end

end
require 'active_support'
require 'active_support/test_case'
ActiveSupport::TestCase.send(:include,UcbCclsEngineFactoryTestHelper)
