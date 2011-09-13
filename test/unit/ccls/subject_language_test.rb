require 'test_helper'

class Ccls::SubjectLanguageTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_initially_belong_to( :study_subject, :language )

	test "should require other if language == other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:language_id => Language['other'].id )
			assert object.errors.on_attr_and_type(:other,:blank)
		end
	end

	test "should not require other if language != other" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(
				:language_id => Language['ENglish'].id )
			assert !object.errors.on_attr_and_type(:other,:blank)
		end
	end

end
