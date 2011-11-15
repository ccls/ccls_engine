require 'test_helper'

class Ccls::RoleTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_require(:name)
	assert_should_require_unique(:name)
	assert_should_habtm(:users)

	test "should create role" do
		assert_difference('Role.count',1) do
			role = create_role
			assert !role.new_record?, 
				"#{role.errors.full_messages.to_sentence}"
		end 
	end

#protected
#
#	def create_role(options = {})
#		role = Factory.build(:role,options)
#		role.save
#		role
#	end

end
