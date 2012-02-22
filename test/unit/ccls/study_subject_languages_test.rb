require 'test_helper'

#	This is just a collection of language related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectLanguagesTest < ActiveSupport::TestCase

	test "should create study_subject with language" do
		assert_difference( 'Language.count', 1 ){
		assert_difference( 'SubjectLanguage.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject
			study_subject.languages << Factory(:language)
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should NOT destroy languages with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('SubjectLanguage.count',1) {
			@study_subject = Factory(:subject_language).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('SubjectLanguage.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy subject_languages with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('SubjectLanguage.count',1) {
			@study_subject = Factory(:subject_language).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('SubjectLanguage.count',0) {
			@study_subject.destroy
		} }
	end

#	add similar for languages?
#	test "should return race name for string" do
#		study_subject = create_study_subject
#		assert_equal study_subject.race_names,
#			"#{study_subject.races.first}"
#	end 

	test "should create study_subject with empty subject_languages_attributes" do
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => { })
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.languages.empty?
		assert @study_subject.subject_languages.empty?
	end

	test "should create study_subject with blank language_id" do
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => { 
				'0' => { :language_id => '' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.languages.empty?
		assert @study_subject.subject_languages.empty?
	end

	test "should create study_subject with subject_languages_attributes language_id" do
		assert Language.count > 0
		assert_difference( 'SubjectLanguage.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => {
				'0' => { :language_id => Language.first.id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.languages.empty?
		assert_equal 1, @study_subject.languages.length
		assert !@study_subject.subject_languages.empty?
		assert_equal 1, @study_subject.subject_languages.length
	end

	test "should create study_subject with subject_languages_attributes multiple languages" do
		assert Language.count > 1
		languages = Language.all
		assert_difference( 'SubjectLanguage.count', 2 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => {
				'0' => { :language_id => languages[0].id },
				'1' => { :language_id => languages[1].id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.languages.empty?
		assert_equal 2, @study_subject.languages.length
		assert !@study_subject.subject_languages.empty?
		assert_equal 2, @study_subject.subject_languages.length
	end

	test "should NOT create study_subject with subject_languages_attributes " <<
			"if language is other and no other given" do
		assert Language.count > 0
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "StudySubject.count", 0 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => {
				'0' => { :language_id => Language['other'].id }
			})
			assert @study_subject.errors.on_attr_and_type?("subject_languages.other",:blank)
		} }
	end

	test "should update study_subject with subject_languages_attributes" do
		study_subject = create_study_subject
		assert_difference( 'SubjectLanguage.count', 1 ){
			study_subject.update_attributes(:subject_languages_attributes => {
				'0' => { :language_id => Language.first.id }
			})
		}
	end

	test "should destroy subject_language on update with _destroy" do
		study_subject = create_study_subject
		assert_difference( 'SubjectLanguage.count', 1 ){
			study_subject.update_attributes(:subject_languages_attributes => {
				'0' => { :language_id => Language.first.id }
			})
		}
		subject_language = study_subject.subject_languages.first
		assert_difference( 'SubjectLanguage.count', -1 ){
			study_subject.update_attributes(:subject_languages_attributes => {
				'0' => { :id => subject_language.id, :_destroy => 1 }
			})
		}
	end

end
