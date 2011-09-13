require 'test_helper'

class Ccls::HomeExposureResponseTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:study_subject)

#	not working
#	assert_should_require_unique_attribute(:study_subject_id)

	test "should require unique study_subject_id" do
		o = create_object
		assert_no_difference "HomeExposureResponse.count" do
			object = create_object(:study_subject => o.study_subject)
			assert object.errors.on_attr_and_type(:study_subject_id, :taken)
		end
	end

	test "should return array of fields" do
		fields = HomeExposureResponse.fields
		assert fields.is_a?(Array)
		assert fields.length > 100
		assert fields.first.is_a?(Hash)
	end

	test "should return array of db_field_names" do
		db_field_names = HomeExposureResponse.db_field_names
		assert db_field_names.is_a?(Array)
		assert db_field_names.length > 100
		assert db_field_names.first.is_a?(String)
	end

	test "should return array of field_names" do
		field_names = HomeExposureResponse.field_names
		assert field_names.is_a?(Array)
		assert field_names.length > 100
	end

#	temporary
	test "should return the same array for field_names and db_field_names" do
		db_field_names = HomeExposureResponse.db_field_names
		field_names = HomeExposureResponse.field_names
		assert_equal field_names, db_field_names
	end

	assert_should_not_require_attributes( *HomeExposureResponse.field_names )

end
