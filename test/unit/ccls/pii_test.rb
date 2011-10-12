require 'test_helper'

class Ccls::PiiTest < ActiveSupport::TestCase

	assert_should_create_default_object

#	assert_should_belong_to(:study_subject)
	assert_should_initially_belong_to(:study_subject)
	assert_should_protect( :study_subject_id )


#	NOTE Used to work, but after changing Subject to StudySubject doesn't?  Should it?
#	assert_should_not_require_attributes( :study_subject_id )
#	Interesting.  There's actually a counter test that tests its requirement??
#	I don't understand how it ever would've worked.



#	assert_should_require_attributes( :study_subject_id )
#	assert_should_require_unique_attributes( :study_subject_id )

	assert_should_belong_to( :guardian_relationship, :class_name => 'SubjectRelationship' )
	assert_should_require_attributes( :dob )
	assert_should_require_unique_attributes( :email )
#	assert_should_not_require_attributes( :first_name )
	assert_should_require_attributes( :first_name )
	assert_should_require_attributes( :last_name )

	assert_should_not_require_attributes( :died_on, 
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:father_first_name, :father_middle_name, :father_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
		:guardian_relationship_other, :email,
		:middle_name, :maiden_name,
		:generational_suffix, :father_generational_suffix )

	assert_should_require_attribute_length( 
		:first_name, :middle_name, :maiden_name, :last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:father_first_name, :father_middle_name, :father_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
		:guardian_relationship_other,
			:maximum => 250 )

	assert_should_require_attribute_length( 
		:generational_suffix, :father_generational_suffix,
			:maximum => 10 )


	assert_requires_complete_date( :dob, :died_on )

	#
	#	study_subject uses accepts_attributes_for :pii
	#	so the pii can't require study_subject_id on create
	#	or this test fails.
	#
#	test "should require study_subject_id on update" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			object.reload.update_attributes(:first_name => "New First Name")
#			assert object.errors.on_attr_and_type(:study_subject,:blank)
#		end
#	end

	test "should require study_subject_id" do
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "#{model_name}.count", 0 ) {
				object = create_object(:study_subject => nil)
			assert object.errors.on_attr_and_type(:study_subject_id, :blank)
		} }
	end

	test "should require unique study_subject_id" do
		study_subject = Factory(:study_subject)
		create_object(:study_subject => study_subject)
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:study_subject => study_subject)
			assert object.errors.on_attr_and_type(:study_subject_id,:taken)
		end
	end

	test "should allow multiple blank email" do
		create_object(:email => '  ')
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:email => ' ')
		end
	end

	test "should require properly formated email address" do
		assert_difference( "#{model_name}.count", 0 ) do
			%w( asdf me@some@where.com me@somewhere ).each do |bad_email|
				object = create_object(:email => bad_email)
				assert object.errors.on_attr_and_type(:email,:invalid)
			end
		end
		assert_difference( "#{model_name}.count", 1 ) do
			%w( me@some.where.com ).each do |good_email|
				object = create_object(:email => good_email)
				assert !object.errors.on_attr_and_type(:email,:invalid)
			end
		end
	end

	test "should return dob as a date NOT time" do
		object = create_object
		assert_changes("Pii.find(#{object.id}).dob") {
			object.update_attribute(:dob, Chronic.parse('tomorrow at noon'))
		}
		assert !object.new_record?
		assert_not_nil object.dob
		assert object.dob.is_a?(Date)
		assert_equal object.dob, object.dob.to_date
	end

	test "should parse a properly formatted date" do
		#	Chronic won't parse this correctly,
		#	but Date.parse will. ???
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(
				:dob => Chronic.parse("January 1 2001"))
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should return join of study_subject's initials" do
		object = create_object(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'JS', object.initials 
	end

	test "should return join of study_subject's name" do
		object = create_object(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'John Smith', object.full_name 
	end

	test "should return join of father's name" do
		object = create_object(
			:father_first_name => "Santa",
			:father_last_name => "Claus" )
		assert_equal 'Santa Claus', object.fathers_name 
	end

	test "should return join of mother's name" do
		object = create_object(
			:mother_first_name => "Ms",
			:mother_last_name => "Claus" )
		assert_equal 'Ms Claus', object.mothers_name 
	end

	test "should return join of guardian's name" do
		object = create_object(
			:guardian_first_name => "Jack",
			:guardian_last_name => "Frost" )
		assert_equal 'Jack Frost', object.guardians_name 
	end

	test "should require guardian_relationship_other if " <<
			"guardian_relationship == other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:guardian_relationship => SubjectRelationship['other'] )
			assert object.errors.on_attr_and_type(:guardian_relationship_other,:blank)
		end
	end

#	test "should touch study_subject after save" do
#		object = create_object
#		assert_not_nil object.study_subject
#		sleep 2
#		assert_changes("StudySubject.find(#{object.study_subject.id}).updated_at") {
#			object.touch
#		}
#	end

end
