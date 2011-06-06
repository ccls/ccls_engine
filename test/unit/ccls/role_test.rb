require 'test_helper'

class Ccls::RoleTest < ActiveSupport::TestCase

#	can't remember why I specified the :model
#	I'll leave commented out for a while
#	and perhaps something will remind me. (110606)
	assert_should_act_as_list	#(:model => 'Role')
	assert_should_require(:name)
#	assert_should_require(:name,
#		:model => 'Role')
	assert_should_require_unique(:name)
#	assert_should_require_unique(:name,
#		:model => 'Role')
	assert_should_habtm(:users)
#	assert_should_habtm(:users,
#		:model => 'Role')

	test "should create role" do
		assert_difference('Role.count',1) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end 
	end

protected

#	def create_object(options = {})
#		record = Factory.build(:role,options)
#		record.save
#		record
#	end

end
