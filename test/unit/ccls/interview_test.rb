require 'test_helper'

class Ccls::InterviewTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_initially_belong_to(:subject)
	assert_should_belong_to( :address )
	assert_should_belong_to( :instrument_version )
	assert_should_belong_to( :interview_method )
	assert_should_belong_to( :language )
	assert_should_belong_to( :subject_relationship )
	assert_should_belong_to( :interviewer, :class_name => 'Person')

	assert_should_not_require_attributes( :address_id )
	assert_should_not_require_attributes( :language_id )
	assert_should_not_require_attributes( :interviewer_id )
	assert_should_not_require_attributes( :instrument_version_id )
	assert_should_not_require_attributes( :interview_method_id )
	assert_should_not_require_attributes( :study_subject_id )
	assert_should_not_require_attributes( :began_on )
	assert_should_not_require_attributes( :ended_on )
	assert_should_not_require_attributes( :intro_letter_sent_on )
	assert_should_not_require_attributes( :consent_read_over_phone )
	assert_should_not_require_attributes( :respondent_requested_new_consent )
	assert_should_not_require_attributes( :consent_reviewed_with_respondent )

	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :subject_relationship_other )
		o.assert_should_require_attribute_length( :respondent_first_name )
		o.assert_should_require_attribute_length( :respondent_last_name )
	end

	assert_requires_complete_date( :began_on )
	assert_requires_complete_date( :ended_on )
	assert_requires_complete_date( :intro_letter_sent_on )

	test "should create intro letter operational event " <<
			"when intro_letter_sent_on set" do
		assert_difference( "OperationalEvent.count", 1 ) {
		assert_difference( "#{model_name}.count", 1 ) {
		assert_difference( "Enrollment.count", 1 ) {
		assert_difference( "Subject.count", 1 ) {
			create_object(
				:subject => create_hx_subject,
				:intro_letter_sent_on => Chronic.parse('yesterday'))
		} } } }
		assert_equal OperationalEventType['intro'],
			OperationalEvent.last.operational_event_type
		assert_equal model_name.constantize.last.intro_letter_sent_on,
			OperationalEvent.last.occurred_on
	end

	test "should update intro letter operational event " <<
			"when intro_letter_sent_on updated" do
		object = create_object(
			:subject => create_hx_subject,
			:intro_letter_sent_on => Chronic.parse('yesterday'))
		assert_difference( "OperationalEvent.count", 0 ) {
		assert_difference( "#{model_name}.count", 0 ) {
			object.update_attribute(:intro_letter_sent_on, Chronic.parse('today'))
		} }
		assert_equal Chronic.parse('today').to_date,
			OperationalEvent.last.occurred_on
	end

	test "should NOT require valid address_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:address_id => 0)
			assert !object.errors.on(:address)
		end
	end

	test "should NOT require valid interviewer_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:interviewer_id => 0)
			assert !object.errors.on(:interviewer)
		end
	end

	test "should NOT require valid instrument_version_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:instrument_version_id => 0)
			assert !object.errors.on(:instrument_version_id)
		end
	end

	test "should NOT require valid interview_method_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:interview_method_id => 0)
			assert !object.errors.on(:interview_method_id)
		end
	end

	test "should NOT require valid language_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:language_id => 0)
			assert !object.errors.on(:language_id)
		end
	end

	test "should NOT require valid study_subject_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:study_subject_id => 0)
			assert !object.errors.on(:study_subject_id)
		end
	end

	test "should return join of respondent's name" do
		object = create_object(
			:respondent_first_name => "Santa",
			:respondent_last_name => "Claus" )
		assert_equal 'Santa Claus', object.respondent_full_name
	end

	test "should require subject_relationship_other if " <<
			"subject_relationship == other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:subject_relationship => SubjectRelationship['other'] )
			assert object.errors.on(:subject_relationship_other)
		end
	end

	test "should NOT ALLOW subject_relationship_other if " <<
			"subject_relationship is blank" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:subject_relationship_id => '',
				:subject_relationship_other => 'asdfasdf' )
			assert object.errors.on(:subject_relationship_other)
		end
	end

	test "should ALLOW subject_relationship_other if " <<
			"subject_relationship != other" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(
				:subject_relationship => Factory(:subject_relationship),
				:subject_relationship_other => 'asdfasdf' )
		end
	end

	test "should require subject_relationship_other with custom message" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:subject_relationship => SubjectRelationship['other'] )
			assert object.errors.on(:subject_relationship_other)
			assert_match /You must specify a relationship with 'other relationship' is selected/, 
				object.errors.full_messages.to_sentence
			assert_no_match /Subject relationship other/, 
				object.errors.full_messages.to_sentence
		end
	end

	%w( began ended ).each do |time|

		test "should NOT create #{time}_at on save if time fields NOT given" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object
				assert_nil object.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_on NOT given" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_interview_with_times("#{time}_on" => nil)
				assert_nil object.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_at_hour NOT given" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_interview_with_times("#{time}_at_hour" => nil)
				assert_nil object.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_at_minute NOT given" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_interview_with_times("#{time}_at_minute" => nil)
				assert_nil object.send("#{time}_at")
			end
		end
	
		test "should NOT create #{time}_at on save if #{time}_at_meridiem NOT given" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_interview_with_times("#{time}_at_meridiem" => nil)
				assert_nil object.send("#{time}_at")
			end
		end
	
		test "should create #{time}_at on save if time fields given" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_interview_with_times
				assert_not_nil object.send("#{time}_at")
				assert_equal object.send("#{time}_at"),
					DateTime.parse("May 12, 2000 1:30 PM PST")
			end
		end

		test "should require #{time}_at_hour be greater than 0" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_interview_with_times("#{time}_at_hour" => 0)
				assert_nil object.send("#{time}_at")
				assert object.errors.on_attr_and_type("#{time}_at_hour",:inclusion)
			end
		end

		test "should require #{time}_at_hour be less than 13" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_interview_with_times("#{time}_at_hour" => 13)
				assert_nil object.send("#{time}_at")
				assert object.errors.on_attr_and_type("#{time}_at_hour",:inclusion)
			end
		end

		test "should require #{time}_at_minute be greater than -1" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_interview_with_times("#{time}_at_minute" => -1)
				assert_nil object.send("#{time}_at")
				assert object.errors.on_attr_and_type("#{time}_at_minute",:inclusion)
			end
		end

		test "should require #{time}_at_minute be less than 60" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_interview_with_times("#{time}_at_minute" => 60)
				assert_nil object.send("#{time}_at")
				assert object.errors.on_attr_and_type("#{time}_at_minute",:inclusion)
			end
		end

		test "should require #{time}_at_meridiem is AM or PM" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_interview_with_times("#{time}_at_meridiem" => 'MM')
				assert_nil object.send("#{time}_at")
				assert object.errors.on_attr_and_type("#{time}_at_meridiem",:invalid)
			end
		end

	end

protected

	def create_interview_with_times(options={})
		ioptions = HashWithIndifferentAccess.new({
			:began_on => Chronic.parse('May 12, 2000').to_date,
			:began_at_hour => 1,
			:began_at_minute => 30,
			:began_at_meridiem => 'PM',
			:ended_on => Chronic.parse('May 12, 2000').to_date,
			:ended_at_hour => 1,
			:ended_at_minute => 30,
			:ended_at_meridiem => 'PM'
 		}).merge(options)
		create_object(ioptions)
	end

end
