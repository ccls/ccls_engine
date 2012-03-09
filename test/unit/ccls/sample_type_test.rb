require 'test_helper'

class Ccls::SampleTypeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list( :scope => :parent_id )
	assert_should_have_many( :samples )
	assert_should_belong_to( :parent, 
		:class_name => 'SampleType' )
	assert_should_have_many( :children,
		:class_name => 'SampleType',
		:foreign_key => 'parent_id' )
	assert_should_not_require_attributes( :position, :parent_id )

	test "should return description as to_s" do
		object = create_object(:description => "Description")
		assert_equal object.description,
			"#{object}"
	end

	test "explicit Factory sample_type test" do
		#	creates sample_type and a parent sample_type
		assert_difference('SampleType.count',2) {	
			sample_type = Factory(:sample_type)
			assert_not_nil sample_type.parent
			assert_match /Key\d*/, sample_type.key
			assert_match /Desc\d*/, sample_type.description
			assert sample_type.is_child?
		}
	end

	test "explicit Factory sample_type parent test" do
		assert_difference('SampleType.count',1) {
			sample_type = Factory(:sample_type_parent)
			assert_nil sample_type.parent
			assert_match /Key\d*/, sample_type.key
			assert_match /Desc\d*/, sample_type.description
			assert sample_type.is_root?
		}
	end

protected

#	The common assertions use create_object, so leave this alone.

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
