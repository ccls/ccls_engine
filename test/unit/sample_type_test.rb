require File.dirname(__FILE__) + '/../test_helper'

class SampleTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list( :scope => :parent_id )
	assert_should_have_many( :samples )
	assert_should_belong_to( :parent, 
		:class_name => 'SampleType' )

#	TODO
#	assert_should_have_many( :children, 
#		:class_name => 'SampleType',
#		:foreign_key => 'parent_id' )

	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :description )
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :parent_id )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :description, :minimum => 4 )
		o.assert_should_require_attribute_length( :code )
	end

	test "should return description as to_s" do
		object = create_object(:description => "Description")
		assert_equal object.description,
			"#{object}"
	end

protected

	def create_object(options = {})
#		record = Factory.build(:sample_type,options)
#	The normal sample_type factory creates a parent 
#	which seems to cause some testing issues unless
#	this was expected so ....
		record = Factory.build(:sample_type_parent,options)
		record.save
		record
	end

end
