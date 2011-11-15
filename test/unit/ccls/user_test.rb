require 'test_helper'

class Ccls::UserTest < ActiveSupport::TestCase

	assert_should_require(:uid)
	assert_should_require_unique(:uid)
	assert_should_habtm(:roles)

	test "should create user" do
		assert_difference 'User.count' do
			user = create_user
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
			assert !user.may_administrate?
		end
	end

	test "should create reader" do
		assert_difference 'User.count' do
			user = create_user
			user.roles << Role.find_by_name('reader')
			assert  user.is_reader?
			assert  user.may_read?
			assert !user.is_administrator?
			assert !user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create interviewer" do
		assert_difference 'User.count' do
			user = create_user
			user.roles << Role.find_by_name('interviewer')
			assert  user.is_interviewer?
			assert  user.may_interview?
			assert  user.may_read?
			assert !user.is_administrator?
			assert !user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create editor" do
		assert_difference 'User.count' do
			user = create_user
			user.roles << Role.find_by_name('editor')
			assert  user.is_editor?
			assert  user.may_edit?
			assert  user.may_interview?
			assert  user.may_read?
			assert !user.is_administrator?
			assert !user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create administrator" do
		assert_difference 'User.count' do
			user = create_user
			user.roles << Role.find_by_name('administrator')
			assert  user.is_administrator?
			assert  user.may_edit?
			assert  user.may_interview?
			assert  user.may_read?
			assert  user.may_administrate?

			assert user.may_view_permissions?
			assert user.may_create_user_invitations?
			assert user.may_view_users?
			assert user.may_assign_roles?
#			assert user.may_edit_subjects?
#			assert user.may_moderate?
#			assert user.moderator?
#			assert user.editor?
			assert user.may_maintain_pages?
#			assert user.may_view_home_page_pics?
#			assert user.may_view_calendar?
#			assert user.may_view_packages?
#			assert user.may_view_subjects?
#			assert user.may_view_dust_kits?
#			assert user.may_view_home_exposures?
#			assert user.may_edit_addresses?
#			assert user.may_edit_enrollments?
#			assert user.employee?
#			assert user.may_view_responses?
#			assert user.may_take_surveys?
#			assert user.may_view_study_events?
#			assert user.may_create_survey_invitations?
			assert user.may_view_user?
			assert user.is_user?(user)
			assert user.may_be_user?(user)
			assert user.may_share_document?('document')
			assert user.may_view_document?('document')

			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should create superuser" do
		assert_difference 'User.count' do
			user = create_user
			user.roles << Role.find_by_name('superuser')
			assert  user.is_superuser?
			assert  user.is_super_user?
			assert  user.may_administrate?
			assert  user.may_edit?
			assert  user.may_interview?
			assert  user.may_read?
			assert  user.may_administrate?
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should deputize to create administrator" do
		u = create_user
		assert !u.role_names.include?('administrator')
		u.deputize
		assert  u.role_names.include?('administrator')
	end

	test "should return non-nil mail" do
		user = create_user
		assert_not_nil user.mail
	end
	test "should respond to roles" do
		user = create_user
		assert user.respond_to?(:roles)
	end

	test "should have many roles" do
		u = create_user
		assert_equal 0, u.roles.length
		roles = Role.all
		assert roles.length > 0
		roles.each do |role|
			assert_difference("User.find(#{u.id}).role_names.length") {
			assert_difference("User.find(#{u.id}).roles.length") {
				u.roles << role
			} }
		end
	end

	test "should return displayname as to_s" do
		user = create_user(:displayname => "Mr Test")
		assert_equal user.displayname, "Mr Test"
		assert_equal user.displayname, "#{user}"
	end

#protected
#
#	def create_user(options = {})
#		user = Factory.build(:user,options)
#		user.save
#		user
#	end
	
end
