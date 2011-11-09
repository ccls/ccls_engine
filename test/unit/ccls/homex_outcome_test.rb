require 'test_helper'

class Ccls::HomexOutcomeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_belong_to( 
		:study_subject, 
		:sample_outcome, 
		:interview_outcome )
	assert_requires_complete_date( 
		:interview_outcome_on, 
		:sample_outcome_on )
	assert_should_not_require_attributes( 
		:position,
		:study_subject_id,
		:sample_outcome_id,
		:sample_outcome_on,
		:interview_outcome_id,
		:interview_outcome_on )

#	TODO Need to add something to allow_nil => true
#	assert_should_require_unique_attribute(:study_subject_id)

	#
	#	study_subject uses accepts_attributes_for :pii
	#	so the pii can't require study_subject_id on create
	#	or this test fails.
	#
	test "should require study_subject_id on update" do
		assert_difference( "HomexOutcome.count", 1 ) do
			homex_outcome = create_homex_outcome
			homex_outcome.reload.update_attributes(:updated_at => Time.now)
			assert homex_outcome.errors.on(:study_subject)
		end
	end

	test "should require unique study_subject_id" do
		study_subject = Factory(:study_subject)
		create_homex_outcome(:study_subject => study_subject)
		assert_difference( "HomexOutcome.count", 0 ) do
			homex_outcome = create_homex_outcome(:study_subject => study_subject)
			assert homex_outcome.errors.on(:study_subject_id)
		end
	end

	test "should require interview_outcome_on if interview_outcome_id?" do
		assert_difference( "HomexOutcome.count", 0 ) do
			homex_outcome = create_homex_outcome(
				:interview_outcome_on => nil,
				:interview_outcome_id => InterviewOutcome.first.id)
			assert homex_outcome.errors.on(:interview_outcome_on)
		end
	end

	test "should require sample_outcome_on if sample_outcome_id?" do
		assert_difference( "HomexOutcome.count", 0 ) do
			homex_outcome = create_homex_outcome(
				:sample_outcome_on => nil,
				:sample_outcome_id => SampleOutcome.first.id)
			assert homex_outcome.errors.on(:sample_outcome_on)
		end
	end

	test "should create operational event when interview scheduled" do
		homex_outcome = create_complete_homex_outcome
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			homex_outcome.update_attributes(
				:interview_outcome_on => past_date,
				:interview_outcome => InterviewOutcome['scheduled'])
		end
		oe = OperationalEvent.last
		assert_equal 'scheduled', oe.operational_event_type.code
		assert_equal past_date,   oe.occurred_on
		assert_equal homex_outcome.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create operational event when interview completed" do
		homex_outcome = create_complete_homex_outcome
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			homex_outcome.update_attributes(
				:interview_outcome_on => past_date,
				:interview_outcome => InterviewOutcome['complete'])
		end
		oe = OperationalEvent.last
		assert_equal 'iv_complete', oe.operational_event_type.code
		assert_equal past_date,   oe.occurred_on
		assert_equal homex_outcome.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create operational event when sample kit sent" do
		homex_outcome = create_complete_homex_outcome
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			homex_outcome.update_attributes(
				:sample_outcome_on => past_date,
				:sample_outcome => SampleOutcome['sent'])
		end
		oe = OperationalEvent.last
		assert_equal 'kit_sent', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal homex_outcome.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create operational event when sample received" do
		homex_outcome = create_complete_homex_outcome
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			homex_outcome.update_attributes(
				:sample_outcome_on => past_date,
				:sample_outcome => SampleOutcome['received'])
		end
		oe = OperationalEvent.last
		assert_equal 'sample_received', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal homex_outcome.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create operational event when sample complete" do
		homex_outcome = create_complete_homex_outcome
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			homex_outcome.update_attributes(
				:sample_outcome_on => past_date,
				:sample_outcome => SampleOutcome['complete'])
		end
		oe = OperationalEvent.last
		assert_equal 'sample_complete', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal homex_outcome.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should raise NoHomeExposureEnrollment on create_interview_outcome_update" <<
			" if no enrollment in HomeExposures" do
pending	#	TODO
	end

	test "should raise NoHomeExposureEnrollment on create_sample_outcome_update" <<
			" if no enrollment in HomeExposures" do
pending	#	TODO
	end

protected

	def create_homex_outcome(options={})
		homex_outcome = Factory.build(:homex_outcome,options)
		homex_outcome.save
		homex_outcome
	end

	def create_complete_homex_outcome(options={})
		s = Factory(:study_subject,options[:study_subject]||{})
		p = Project.find_or_create_by_code('HomeExposures')
		Factory(:enrollment, :study_subject => s, :project => p )
		h = create_homex_outcome(
			(options[:homex_outcome]||{}).merge(:study_subject => s,
			:interview_outcome_on => nil,
			:sample_outcome_on => nil))
		h
	end

end
