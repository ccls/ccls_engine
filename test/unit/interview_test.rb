require File.dirname(__FILE__) + '/../test_helper'

class InterviewTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:identifier)
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
	assert_should_not_require_attributes( :identifier_id )
	assert_should_not_require_attributes( :began_on )
	assert_should_not_require_attributes( :ended_on )
	assert_should_not_require_attributes( :intro_letter_sent_on )
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
		assert_difference( "Identifier.count", 1 ) {
		assert_difference( "Subject.count", 1 ) {
			create_object(
				:identifier => create_hx_subject.identifier,
				:intro_letter_sent_on => Chronic.parse('yesterday'))
		} } } } }
		assert_equal OperationalEventType['intro'],
			OperationalEvent.last.operational_event_type
		assert_equal model_name.constantize.last.intro_letter_sent_on,
			OperationalEvent.last.occurred_on
	end

	test "should update intro letter operational event " <<
			"when intro_letter_sent_on updated" do
		object = create_object(
			:identifier => create_hx_subject.identifier,
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

	test "should NOT require valid identifier_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:identifier_id => 0)
			assert !object.errors.on(:identifier_id)
		end
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
			"subject_relationship != other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:subject_relationship => Factory(:subject_relationship),
				:subject_relationship_other => 'asdfasdf' )
			assert object.errors.on(:subject_relationship_other)
		end
	end

end
