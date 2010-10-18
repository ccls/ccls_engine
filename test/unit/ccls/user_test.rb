require File.dirname(__FILE__) + '/../../test_helper'

class Ccls::UserTest < ActiveSupport::TestCase

	assert_should_require(:uid,
		:model => 'User')
	assert_should_require_unique(:uid,
		:model => 'User')
	assert_should_habtm(:roles,
		:model => 'User')

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

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	test "should require password matching confirmation" do
#		assert_no_difference 'User.count' do
#			u = create_user(
#				:password              => 'alpha',
#				:password_confirmation => 'beta')
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password_confirmation" do
#		assert_no_difference 'User.count' do
#			u = create_user(:password_confirmation => nil)
#			assert u.errors.on(:password_confirmation)
#		end
#	end
#
#	test "should require password" do
#		assert_no_difference 'User.count' do
#			u = create_user(:password => nil)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with at least 8 chars" do
#		invalid_password = "1nV@l!d"
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with symbol" do
#		invalid_password = Factory.attributes_for(:user
#			)[:password].gsub(/\W/,'a')
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with number" do
#		invalid_password = Factory.attributes_for(:user
#			)[:password].gsub(/\d/,'a')
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with lowercase letter" do
#		invalid_password = Factory.attributes_for(:user)[:password].upcase
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require password with uppercase letter" do
#		invalid_password = Factory.attributes_for(:user)[:password].downcase
#		assert_no_difference 'User.count' do
#			u = create_user(:password => invalid_password,
#				:password_confirmation => invalid_password)
#			assert u.errors.on(:password)
#		end
#	end
#
#	test "should require properly formated email address" do
#		assert_no_difference 'User.count' do
#			u = create_user(:email => 'blah blah blah')
#			assert u.errors.on(:email)
#		end
#	end
#
#	test "should require email" do
#		assert_no_difference 'User.count' do
#			u = create_user(:email => nil)
#			assert u.errors.on(:email)
#		end
#	end
#
#	test "should require unique email" do
#		user = create_user
#		assert_no_difference 'User.count' do
#			u = create_user(:email => user.email)
#			assert u.errors.on(:email)
#		end
#	end
#
#	test "should require username" do
#		assert_no_difference 'User.count' do
#			u = create_user(:username => nil)
#			assert u.errors.on(:username)
#		end
#	end
#
#	test "should require unique username" do
#		user = create_user
#		assert_no_difference 'User.count' do
#			u = create_user(:username => user.username)
#			assert u.errors.on(:username)
#		end
#	end
#
#	test "should require unique perishable token" do
#		user = create_user
#		user.reload
#		assert_not_nil user.perishable_token
#		Authlogic::Random.stubs(:friendly_token).returns(user.perishable_token)
#		User.stubs(:find_by_perishable_token).returns(nil)
#		assert_difference('User.count',0) do
#			#	Just build the user
#			u = Factory.build(:user)
#			#	Then force the perishable token
#			u.reset_perishable_token
#			#	Then save which will validate and raise a
#			#	validation error.
#			assert_not_nil u.perishable_token
#			u.save
#			assert u.errors.on(:perishable_token)
#		end
#	end
#
#	test "should require unique persistence token" do
#		user = create_user
#		user.reload
#		assert_not_nil user.persistence_token
#		Authlogic::Random.stubs(:hex_token).returns(user.persistence_token)
#		User.stubs(:find_by_persistence_token).returns(nil)
#		assert_difference('User.count',0) do
#			u = create_user
#			assert_not_nil u.persistence_token
#			assert u.errors.on(:persistence_token)
#		end
#	end
#
#	test "should respond to extended methods" do
#		user = create_user
#		assert user.respond_to?(:reset_persistence_token_with_uniqueness)
#		assert user.respond_to?(:reset_perishable_token_with_uniqueness)
#		assert user.respond_to?(:reset_persistence_token_without_uniqueness)
#		assert user.respond_to?(:reset_perishable_token_without_uniqueness)
#	end


	test "should deputize to create administrator" do
		u = create_user
		assert !u.role_names.include?('administrator')
		u.deputize
		assert  u.role_names.include?('administrator')
	end

#	test "should return non-nil email" do
#		user = create_user
#		assert_not_nil user.email
#	end

	test "should return non-nil mail" do
		user = create_user
		assert_not_nil user.mail
	end

	test "should return non-nil gravatar_url" do
		user = create_user
		assert_not_nil user.gravatar_url
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

protected

	#
	#	This method is used so that an invalid user produces errors
	#	rather than raises exceptions which will cause the tests to fail.
	#
	def create_user(options = {})
		record = Factory.build(:user,options)
		record.save
		record
	end
	alias_method :create_object, :create_user
	
end
