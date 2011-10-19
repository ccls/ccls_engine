require 'test_helper'

class Ccls::ProjectOutcomeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position, :project_id )
	assert_should_have_many( :enrollments )
	assert_should_require_attribute_length( :code, :description, 
		:maximum => 250 )

	test "should return description as to_s" do
		project_outcome = create_project_outcome
		assert_equal project_outcome.description,
			"#{project_outcome}"
	end

protected

	def create_project_outcome(options={})
		project_outcome = Factory.build(:project_outcome,options)
		project_outcome.save
		project_outcome
	end

end
