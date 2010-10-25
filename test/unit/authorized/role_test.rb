require File.dirname(__FILE__) + '/../../test_helper'

class SimplyAuthorized::RoleTest < ActiveSupport::TestCase

	assert_should_act_as_list(:model => 'Role')
	assert_should_require(:name,
		:model => 'Role')
	assert_should_require_unique(:name,
		:model => 'Role')
	assert_should_habtm(:users,
		:model => 'Role')

	test "should create role" do
		assert_difference('Role.count',1) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end 
	end

protected

	def create_object(options = {})
		record = Factory.build(:role,options)
		record.save
		record
	end

end
