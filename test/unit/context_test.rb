require File.dirname(__FILE__) + '/../test_helper'

class ContextTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code)
	assert_should_require_attributes(:description)
	assert_should_require_unique_attributes(:code)
	assert_should_require_unique_attributes(:description)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :notes )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :code )
		o.assert_should_require_attribute_length( :description, :minimum => 4 )
	end
	assert_should_act_as_list
	assert_should_have_many(:units)

end
