require 'test_helper'

class Ccls::DocumentTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:document_versions)
	assert_should_require_attributes( :title )
	assert_should_not_require_attributes( :position, :description )
	assert_should_require_attribute_length( 
		:title, 
		:description, 
			:maximum => 250 )

	test "explicit Factory document_type test" do
		assert_difference('DocumentType.count',1) {
			document_type = Factory(:document_type)
			assert_match /Title\d*/,  document_type.title
		}
	end

	test "should return title as to_s" do
		document_type = create_document_type
		assert_equal document_type.title, "#{document_type}"
	end

#protected
#
#	def create_document_type(options={})
#		document_type = Factory.build(:document_type,options)
#		document_type.save
#		document_type
#	end

end
