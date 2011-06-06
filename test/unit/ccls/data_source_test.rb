require 'test_helper'

class Ccls::DataSourceTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:addresses)
	assert_should_not_require_attributes( :position, :research_origin, :data_origin )
	assert_should_require_attribute_length( :research_origin, :data_origin, 
		:maximum => 250 )
end
