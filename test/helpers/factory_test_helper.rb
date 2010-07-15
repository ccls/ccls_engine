module FactoryTestHelper

	def active_user(options={})
		u = Factory(:user, options)
		#	leave this special save here just in case I change things.
		#	although this would need changed for UCB CAS.
		#	u.save_without_session_maintenance
		#	u
	end
	alias_method :user, :active_user

	def admin_user(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('administrator')
		u
	end
	alias_method :admin, :admin_user

	def employee_user(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('employee')
		u
	end
	alias_method :employee, :employee_user

	def editor(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('editor')
		u
	end

	def moderator(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('moderator')
		u
	end

end
ActiveSupport::TestCase.send(:include,FactoryTestHelper)
