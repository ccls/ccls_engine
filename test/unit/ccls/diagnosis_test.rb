require 'test_helper'

class Ccls::DiagnosisTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes(:position)
	assert_should_require_attribute_length( :description, :in => 3..250 )
	assert_should_act_as_list

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

end
