require 'test_helper'

class Ccls::TransferTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to( :aliquot )
	assert_should_initially_belong_to( :to_organization, :from_organization, 
		:class_name => 'Organization' )
	assert_should_require_attributes( :aliquot_id, 
		:from_organization_id, :to_organization_id )
	assert_should_not_require_attributes( :position, :amount, :reason, :is_permanent )
	assert_should_require_attribute_length( :reason, :maximum => 250 )

end
