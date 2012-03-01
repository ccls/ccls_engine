require 'test_helper'

class Ccls::StudySubjectHomexOutcomeTest < ActiveSupport::TestCase

	test "should create study_subject and accept_nested_attributes_for homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	#	StudySubject currently accepts nested attributes for homex_outcome,
	#	but an empty homex_outcome is no longer invalid.
	test "should create study_subject with empty homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( 'StudySubject.count', 1) {
			study_subject = create_study_subject( :homex_outcome_attributes => {})
		} }
	end

	test "should NOT destroy homex_outcome with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('HomexOutcome.count',1) {
			@study_subject = Factory(:study_subject)
			Factory(:homex_outcome, :study_subject => @study_subject)
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('HomexOutcome.count',0) {
			@study_subject.destroy
		} }
	end

	#	Delegated homex_outcome fields
	%w( interview_outcome sample_outcome
			interview_outcome_on sample_outcome_on 
		).each do |method_name|

		test "should respond to #{method_name}" do
			study_subject = create_study_subject
			assert study_subject.respond_to?(method_name)
		end

	end

	#	Delegated homex_outcome fields except ... interview_outcome, sample_outcome
	%w( interview_outcome_on sample_outcome_on ).each do |method_name|

		test "should return nil #{method_name} without homex_outcome" do
			study_subject = create_study_subject
			assert_nil study_subject.send(method_name)
		end

		test "should return #{method_name} with homex_outcome" do
			study_subject = create_study_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert_not_nil study_subject.send(method_name)
		end

	end

end
