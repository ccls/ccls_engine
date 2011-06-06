require 'test_helper'

class Ccls::DocumentTypeTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:document_versions)
	assert_should_require_attributes( :title )
	assert_should_not_require_attributes( :position, :description )
	assert_should_require_attribute_length( :title, :description, 
		:maximum => 250 )

	test "should return title as to_s" do
		object = create_object
		assert_equal object.title, "#{object}"
	end

end
