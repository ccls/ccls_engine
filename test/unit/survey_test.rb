require File.dirname(__FILE__) + '/../test_helper'

class SurveyTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many( :response_sets )
	assert_should_require_attribute( :title )
	assert_should_not_require_attributes( :description )
	assert_should_not_require_attributes( :access_code )
	assert_should_not_require_attributes( :reference_identifier )
	assert_should_not_require_attributes( :data_export_identifier )
	assert_should_not_require_attributes( :common_namespace )
	assert_should_not_require_attributes( :common_identifier )
	assert_should_not_require_attributes( :active_at )
	assert_should_not_require_attributes( :inactive_at )
	assert_should_not_require_attributes( :css_url )
	assert_should_not_require_attributes( :custom_class )
	assert_should_not_require_attributes( :display_order )
	assert_should_not_require_attributes( :manual_numbering )


	test "should require unique access_code" do
		Survey.stubs(:find_by_access_code).returns(nil)
		s = create_survey(:title => "non unique title")
		assert_difference( "#{model_name}.count", 0 ) do
			survey = create_survey(:title => "non unique title")
			assert survey.errors.on(:access_code)
		end
	end

	test "should replace non unique access_code" do
		s = create_survey(:title => "non unique title")
		assert_difference( "#{model_name}.count", 1 ) do
			survey = create_survey(:title => "non unique title")
			assert_equal "non-unique-title_2", survey.access_code
		end
	end

	test "should update access_code on title change" do
		survey = create_survey(:title => "non unique title")
		assert_equal "non-unique-title", survey.access_code
		survey.title = "My New Title"
		assert_equal "my-new-title", survey.access_code
	end

	test "should update and uniquify access_code on title change" do
		s = create_survey(:title => "my new title")
		survey = create_survey(:title => "non unique title")
		assert_equal "non-unique-title", survey.access_code
		survey.title = "My New Title"
		assert_equal "my-new-title_2", survey.access_code
	end

end
