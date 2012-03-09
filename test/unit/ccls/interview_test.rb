require 'test_helper'

class Ccls::InterviewTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:study_subject)
	assert_should_protect( :study_subject_id, :study_subject )
	assert_should_belong_to( :address,
		:instrument_version,
		:interview_method,
		:language,
		:subject_relationship )
	assert_should_belong_to( :interviewer, :class_name => 'Person')
	assert_should_not_require_attributes( 
		:address_id,
		:language_id,
		:interviewer_id,
		:instrument_version_id,
		:interview_method_id,
		:study_subject_id,
		:began_on,
		:ended_on,
		:intro_letter_sent_on,
		:consent_read_over_phone,
		:respondent_requested_new_consent,
		:consent_reviewed_with_respondent )
	assert_should_require_attribute_length( 
		:subject_relationship_other, 
		:respondent_first_name,
		:respondent_last_name, 
			:maximum => 250 )
	assert_requires_complete_date( :began_on, :ended_on, :intro_letter_sent_on )
	assert_should_protect( :began_at, :ended_at )

	test "explicit Factory interview test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Interview.count',1) {
			interview = Factory(:interview)
			assert_not_nil interview.study_subject
		} }
	end

	test "should create intro letter operational event " <<
			"when intro_letter_sent_on set" do
		study_subject = create_hx_study_subject
		assert_difference( "OperationalEvent.count", 1 ) {
		assert_difference( "Interview.count", 1 ) {
			@interview = create_interview( :study_subject => study_subject,
				:intro_letter_sent_on => Date.yesterday ).reload
		} }
		assert_equal OperationalEventType['intro'],
			OperationalEvent.last.operational_event_type
		assert_equal @interview.intro_letter_sent_on,
			OperationalEvent.last.occurred_on
	end

	test "should update intro letter operational event " <<
			"when intro_letter_sent_on updated" do
		interview = create_interview(
			:study_subject => create_hx_study_subject,
			:intro_letter_sent_on => Date.yesterday )
		assert_difference( "OperationalEvent.count", 0 ) {
		assert_difference( "Interview.count", 0 ) {
			interview.update_attributes(:intro_letter_sent_on => Date.today )
		} }
		assert_equal Date.today,
			OperationalEvent.last.occurred_on
	end

	test "should NOT require valid address_id" do
		assert_difference( "Interview.count", 1 ) do
			interview = create_interview(:address_id => 0)
			assert !interview.errors.on(:address)
		end
	end

	test "should NOT require valid interviewer_id" do
		assert_difference( "Interview.count", 1 ) do
			interview = create_interview(:interviewer_id => 0)
			assert !interview.errors.on(:interviewer)
		end
	end

	test "should NOT require valid instrument_version_id" do
		assert_difference( "Interview.count", 1 ) do
			interview = create_interview(:instrument_version_id => 0)
			assert !interview.errors.on(:instrument_version_id)
		end
	end

	test "should NOT require valid interview_method_id" do
		assert_difference( "Interview.count", 1 ) do
			interview = create_interview(:interview_method_id => 0)
			assert !interview.errors.on(:interview_method_id)
		end
	end

	test "should NOT require valid language_id" do
		assert_difference( "Interview.count", 1 ) do
			interview = create_interview(:language_id => 0)
			assert !interview.errors.on(:language_id)
		end
	end

	test "should NOT require valid study_subject_id" do
		assert_difference( "Interview.count", 1 ) do
			interview = create_interview(:study_subject_id => 0)
			assert !interview.errors.on(:study_subject_id)
		end
	end

	test "should return join of respondent's name" do
		interview = create_interview(
			:respondent_first_name => "Santa",
			:respondent_last_name => "Claus" )
		assert_equal 'Santa Claus', interview.respondent_full_name
	end

	test "should require subject_relationship_other if " <<
			"subject_relationship == other" do
		assert_difference( "Interview.count", 0 ) do
			interview = create_interview(
				:subject_relationship => SubjectRelationship['other'] )
			assert interview.errors.on(:subject_relationship_other)
		end
	end

	test "should NOT ALLOW subject_relationship_other if " <<
			"subject_relationship is blank" do
		assert_difference( "Interview.count", 0 ) do
			interview = create_interview(
				:subject_relationship_id => '',
				:subject_relationship_other => 'asdfasdf' )
			assert interview.errors.on(:subject_relationship_other)
		end
	end

	test "should ALLOW subject_relationship_other if " <<
			"subject_relationship != other" do
		assert_difference( "Interview.count", 1 ) do
			interview = create_interview(
				:subject_relationship => Factory(:subject_relationship),
				:subject_relationship_other => 'asdfasdf' )
		end
	end

	test "should require subject_relationship_other with custom message" do
		assert_difference( "Interview.count", 0 ) do
			interview = create_interview(
				:subject_relationship => SubjectRelationship['other'] )
			assert interview.errors.on(:subject_relationship_other)
			assert_match /You must specify a relationship with 'other relationship' is selected/, 
				interview.errors.full_messages.to_sentence
			assert_no_match /Subject relationship other/, 
				interview.errors.full_messages.to_sentence
		end
	end

	%w( began ended ).each do |time|

		test "should NOT create #{time}_at on save if time fields NOT given" do
			assert_difference( "Interview.count", 1 ) do
				interview = create_interview
				assert_nil interview.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_on NOT given" do
			assert_difference( "Interview.count", 1 ) do
				interview = create_interview_with_times("#{time}_on" => nil)
				assert_nil interview.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_at_hour NOT given" do
			assert_difference( "Interview.count", 1 ) do
				interview = create_interview_with_times("#{time}_at_hour" => nil)
				assert_nil interview.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_at_minute NOT given" do
			assert_difference( "Interview.count", 1 ) do
				interview = create_interview_with_times("#{time}_at_minute" => nil)
				assert_nil interview.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_at_meridiem NOT given" do
			assert_difference( "Interview.count", 1 ) do
				interview = create_interview_with_times("#{time}_at_meridiem" => nil)
				assert_nil interview.send("#{time}_at")
			end
		end
	
		test "should create #{time}_at on save if time fields given" do
			assert_difference( "Interview.count", 1 ) do
				interview = create_interview_with_times
				assert_not_nil interview.send("#{time}_at")
				assert_equal interview.send("#{time}_at"),
					DateTime.parse("May 12, 2000 1:30 PM")
#					DateTime.parse("May 12, 2000 1:30 PM PST")
			end
		end

		test "should nilify #{time}_at on update if #{time}_on NOT given" do
			interview = create_interview_with_times
			assert_not_nil interview.send("#{time}_at")
			interview.update_attributes("#{time}_on" => nil)
			assert_nil interview.send("#{time}_at")
		end

		test "should nilify #{time}_at on update if #{time}_at_hour NOT given" do
			interview = create_interview_with_times
			assert_not_nil interview.send("#{time}_at")
			interview.update_attributes("#{time}_at_hour" => nil)
			assert_nil interview.send("#{time}_at")
		end

		test "should nilify #{time}_at on update if #{time}_at_minute NOT given" do
			interview = create_interview_with_times
			assert_not_nil interview.send("#{time}_at")
			interview.update_attributes("#{time}_at_minute" => nil)
			assert_nil interview.send("#{time}_at")
		end

		test "should nilify #{time}_at on update if #{time}_at_meridiem NOT given" do
			interview = create_interview_with_times
			assert_not_nil interview.send("#{time}_at")
			interview.update_attributes("#{time}_at_meridiem" => nil)
			assert_nil interview.send("#{time}_at")
		end

		test "should require #{time}_at_hour be greater than 0" do
			assert_difference( "Interview.count", 0 ) do
				interview = create_interview_with_times("#{time}_at_hour" => 0)
				assert_nil interview.send("#{time}_at")
				assert interview.errors.on_attr_and_type?("#{time}_at_hour",:inclusion)
			end
		end

		test "should require #{time}_at_hour be less than 13" do
			assert_difference( "Interview.count", 0 ) do
				interview = create_interview_with_times("#{time}_at_hour" => 13)
				assert_nil interview.send("#{time}_at")
				assert interview.errors.on_attr_and_type?("#{time}_at_hour",:inclusion)
			end
		end

		test "should require #{time}_at_minute be greater than -1" do
			assert_difference( "Interview.count", 0 ) do
				interview = create_interview_with_times("#{time}_at_minute" => -1)
				assert_nil interview.send("#{time}_at")
				assert interview.errors.on_attr_and_type?("#{time}_at_minute",:inclusion)
			end
		end

		test "should require #{time}_at_minute be less than 60" do
			assert_difference( "Interview.count", 0 ) do
				interview = create_interview_with_times("#{time}_at_minute" => 60)
				assert_nil interview.send("#{time}_at")
				assert interview.errors.on_attr_and_type?("#{time}_at_minute",:inclusion)
			end
		end

		test "should require #{time}_at_meridiem is AM or PM" do
			assert_difference( "Interview.count", 0 ) do
				interview = create_interview_with_times("#{time}_at_meridiem" => 'MM')
				assert_nil interview.send("#{time}_at")
				assert interview.errors.on_attr_and_type?("#{time}_at_meridiem",:invalid)
			end
		end

	end

protected

#	def create_interview(options={})
#		interview = Factory.build(:interview,options)
#		interview.save
#		interview
#	end

	def create_interview_with_times(options={})
		ioptions = HashWithIndifferentAccess.new({
			:began_on => Date.parse('May 12, 2000'),
			:began_at_hour => 1,
			:began_at_minute => 30,
			:began_at_meridiem => 'PM',
			:ended_on => Date.parse('May 12, 2000'),
			:ended_at_hour => 1,
			:ended_at_minute => 30,
			:ended_at_meridiem => 'PM'
 		}).merge(options)
		create_interview(ioptions)
	end

end
