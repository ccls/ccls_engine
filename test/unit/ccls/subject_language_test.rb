require 'test_helper'

class Ccls::SubjectLanguageTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to( :study_subject, :language )

	test "should require other if language == other" do
		assert_difference( "SubjectLanguage.count", 0 ) do
			subject_language = create_subject_language(
				:language_id => Language['other'].id )
			assert subject_language.errors.on_attr_and_type(:other,:blank)
		end
	end

	test "should not require other if language != other" do
		assert_difference( "SubjectLanguage.count", 1 ) do
			subject_language = create_subject_language(
				:language_id => Language['ENglish'].id )
			assert !subject_language.errors.on_attr_and_type(:other,:blank)
		end
	end

protected

	def create_subject_language(options={})
		subject_language = Factory.build(:subject_language,options)
		subject_language.save
		subject_language
	end

end
