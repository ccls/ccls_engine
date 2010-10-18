require File.dirname(__FILE__) + '/../../test_helper'

class Ccls::UserInvitationTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:sender,
		:model => 'UserInvitation')
	assert_should_initially_belong_to(:sender,:class_name => 'User',
		:model => 'UserInvitation')
	assert_should_require(:email,
		:model => 'UserInvitation')

	test "should create invitation" do
		assert_difference 'UserInvitation.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should generate token before validation" do
		object = Factory.build(:user_invitation)
		assert_nil object.token
		assert object.valid?
		assert_not_nil object.token
	end

	test "should generate unique token before create" do
		i = create_object
		UserInvitation.any_instance.stubs(:generate_unique_token).returns(true)
		assert_difference( 'UserInvitation.count', 0 ) do
			object = create_object(:token => i.token)
			assert object.errors.on(:token)
		end
	end

	test "should be findable by token" do
		ui = UserInvitation.find_by_token('blah blah blah')
		assert_nil ui
		object = create_object
		ui = UserInvitation.find_by_token(object.token)
		assert_not_nil ui
	end

	test "should not change token on invitation update" do
		i = create_object
		before = i.token
		i.update_attribute(:email, "me@here.com")
		after = i.reload.token
		assert_equal before, after
	end

#	Not using this, so pending tests are more pointless
#	than the functioning ones.
#
#	test "should require properly formated email address" do
#		pending
#	end
#
#	test "should expire?" do
#		pending
#	end
#
#	test "should be usable once and only once" do
#		pending
#	end
#
#	test "should belong to a recipient after used" do
#		pending
#	end
#
#	test "should accept a message" do
#		pending
#	end

protected

	def create_object(options={})
		record = Factory.build(:user_invitation,options)
		record.save
		record
	end

end
