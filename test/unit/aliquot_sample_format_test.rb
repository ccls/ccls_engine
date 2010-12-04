require File.dirname(__FILE__) + '/../test_helper'

class AliquotSampleFormatTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code)
	assert_should_require_attributes(:description)
	assert_should_require_unique_attributes(:code)
	assert_should_require_unique_attributes(:description)
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length(:description, :minimum => 4 )
		o.assert_should_require_attribute_length( :code )
	end
	assert_should_not_require_attributes(:position)
	assert_should_act_as_list
	assert_should_have_many(:aliquots)
	assert_should_have_many(:samples)

end
