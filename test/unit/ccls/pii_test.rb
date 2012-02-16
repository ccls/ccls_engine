require 'test_helper'

#	TODO these tests will need to be included in study subject's tests
#		As unit tests are not explicitly linked to a model,
#		only my class level assertions immediately matter.

class Ccls::PiiTest < ActiveSupport::TestCase
#
#	assert_should_create_default_object
#
#	assert_should_initially_belong_to(:study_subject)
#	assert_should_protect( :study_subject_id )
#
#	assert_should_belong_to( :guardian_relationship, :class_name => 'SubjectRelationship' )
#	assert_should_require_attributes( :dob )
#	assert_should_require_unique_attributes( :email )
#	assert_should_not_require_attributes( :first_name, :last_name,
#		:died_on, :birth_year,
#		:birth_city, :birth_state, :birth_country,
#		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
#		:father_first_name, :father_middle_name, :father_last_name,
#		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
#		:guardian_relationship_other, :email,
#		:middle_name, :maiden_name,
#		:mother_race_other, :father_race_other,
#		:generational_suffix, :father_generational_suffix )
#
#	assert_should_require_attribute_length( 
#		:first_name, :middle_name, :maiden_name, :last_name,
#		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
#		:father_first_name, :father_middle_name, :father_last_name,
#		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
#		:guardian_relationship_other,
#		:birth_city, :birth_state, :birth_country,
#		:mother_race_other, :father_race_other,
#			:maximum => 250 )
#
#	assert_should_require_attribute_length( :generational_suffix, :maximum => 10 )
#	assert_should_require_attribute_length( :father_generational_suffix, :maximum => 10 )
#	assert_should_require_attribute_length( :birth_year, :maximum => 4 )
#	assert_requires_complete_date( :dob )
#	assert_requires_complete_date( :died_on )
#
#	test "explicit Factory subjectless pii test" do
#		assert_difference('StudySubject.count',0) {
#		assert_difference('Pii.count',1) {
#			pii = Factory(:subjectless_pii)
#			assert_nil pii.study_subject
#			assert_not_nil pii.email
#			assert_not_nil pii.dob
#		} }
#	end
#
#	test "explicit Factory pii test" do
#		assert_difference('StudySubject.count',1) {
#		assert_difference('Pii.count',1) {
#			pii = Factory(:pii)
#			assert_not_nil pii.study_subject
#		} }
#	end
#
#	test "explicit Factory case pii test" do
#		assert_difference('StudySubject.count',1) {
#		assert_difference('Pii.count',1) {
#			pii = Factory(:case_pii)
#			assert_not_nil pii.study_subject
#			assert_equal pii.study_subject.subject_type, SubjectType['Case']
#		} }
#	end

	test "should nullify blank email" do
		assert_difference("StudySubject.count",1) do
			study_subject = create_study_subject(:email => ' ')
			assert_nil study_subject.reload.email
		end
	end

	test "should allow multiple blank email" do
		create_study_subject(:email => '  ')
		assert_difference( "StudySubject.count", 1 ) do
			study_subject = create_study_subject(:email => ' ')
		end
	end

	test "should require properly formated email address" do
		assert_difference( "StudySubject.count", 0 ) do
			%w( asdf me@some@where.com me@somewhere ).each do |bad_email|
				study_subject = create_study_subject(:email => bad_email)
				assert study_subject.errors.on_attr_and_type?(:email,:invalid)
			end
		end
		assert_difference( "StudySubject.count", 1 ) do
			%w( me@some.where.com ).each do |good_email|
				study_subject = create_study_subject(:email => good_email)
				assert !study_subject.errors.on_attr_and_type?(:email,:invalid)
			end
		end
	end

	test "should return dob as a date NOT time" do
		study_subject = create_study_subject(:dob => (Time.now - 5.days) )
		assert_not_nil study_subject.dob
		assert_changes("StudySubject.find(#{study_subject.id}).dob") {
			study_subject.update_attributes(:dob => (Time.now - 4.days) )
		}
		assert !study_subject.new_record?
		assert_not_nil study_subject.dob
		assert study_subject.dob.is_a?(Date)
		assert_equal study_subject.dob, study_subject.dob.to_date
	end

	test "should parse a properly formatted date" do
		assert_difference( "StudySubject.count", 1 ) do
			study_subject = create_study_subject(
				:dob => Date.parse("January 1 2001") )
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		end
	end

	test "should return join of study_subject's initials" do
		study_subject = create_study_subject(
			:first_name => "John",
			:middle_name => "X",
			:last_name  => "Smith" )
		assert_equal 'JXS', study_subject.initials 
	end

	test "should return join of study_subject's initials without middle name" do
		study_subject = create_study_subject(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'JS', study_subject.initials 
	end

	test "should return join of study_subject's initials with blank middle name" do
		study_subject = create_study_subject(
			:first_name => "John",
			:middle_name => "",
			:last_name  => "Smith" )
		assert_equal 'JS', study_subject.initials 
	end

	test "should return join of study_subject's name" do
		study_subject = create_study_subject(
			:first_name => "John",
			:middle_name => "Xavier",
			:last_name  => "Smith" )
		assert_equal 'John Xavier Smith', study_subject.full_name 
	end

	test "should return join of study_subject's name without middle name" do
		study_subject = create_study_subject(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'John Smith', study_subject.full_name 
	end

	test "should return join of study_subject's name with blank middle name" do
		study_subject = create_study_subject(
			:first_name => "John",
			:middle_name => "",
			:last_name  => "Smith" )
		assert_equal 'John Smith', study_subject.full_name 
	end

	test "should return 'name not available' if study_subject's names are blank" do
		study_subject = create_study_subject
		assert_equal '[name not available]', study_subject.full_name 
	end

	test "should return 'name not available' if study_subject's father's names are blank" do
		study_subject = create_study_subject
		assert_equal '[name not available]', study_subject.fathers_name
	end

	test "should return 'name not available' if study_subject's mother's names are blank" do
		study_subject = create_study_subject
		assert_equal '[name not available]', study_subject.mothers_name
	end

	test "should return 'name not available' if study_subject's guardian's names are blank" do
		study_subject = create_study_subject
		assert_equal '[name not available]', study_subject.guardians_name
	end

	test "should return join of father's name" do
		study_subject = create_study_subject(
			:father_first_name => "Santa",
			:father_middle_name => "X.",
			:father_last_name => "Claus" )
		assert_equal 'Santa X. Claus', study_subject.fathers_name 
	end

	test "should return join of father's name without middle name" do
		study_subject = create_study_subject(
			:father_first_name => "Santa",
			:father_last_name => "Claus" )
		assert_equal 'Santa Claus', study_subject.fathers_name 
	end

	test "should return join of father's name with blank middle name" do
		study_subject = create_study_subject(
			:father_first_name => "Santa",
			:father_middle_name => "",
			:father_last_name => "Claus" )
		assert_equal 'Santa Claus', study_subject.fathers_name 
	end

	test "should return join of mother's name" do
		study_subject = create_study_subject(
			:mother_first_name => "Ms",
			:mother_middle_name => "X.",
			:mother_last_name => "Claus" )
		assert_equal 'Ms X. Claus', study_subject.mothers_name 
	end

	test "should return join of mother's name without middle name" do
		study_subject = create_study_subject(
			:mother_first_name => "Ms",
			:mother_last_name => "Claus" )
		assert_equal 'Ms Claus', study_subject.mothers_name 
	end

	test "should return join of mother's name with blank middle name" do
		study_subject = create_study_subject(
			:mother_first_name => "Ms",
			:mother_middle_name => "",
			:mother_last_name => "Claus" )
		assert_equal 'Ms Claus', study_subject.mothers_name 
	end

	test "should return join of guardian's name" do
		study_subject = create_study_subject(
			:guardian_first_name => "Jack",
			:guardian_middle_name => "X.",
			:guardian_last_name => "Frost" )
		assert_equal 'Jack X. Frost', study_subject.guardians_name 
	end

	test "should return join of guardian's name without middle name" do
		study_subject = create_study_subject(
			:guardian_first_name => "Jack",
			:guardian_last_name => "Frost" )
		assert_equal 'Jack Frost', study_subject.guardians_name 
	end

	test "should return join of guardian's name with blank middle name" do
		study_subject = create_study_subject(
			:guardian_first_name => "Jack",
			:guardian_middle_name => "",
			:guardian_last_name => "Frost" )
		assert_equal 'Jack Frost', study_subject.guardians_name 
	end

	test "should require guardian_relationship_other if " <<
			"guardian_relationship == other" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject(
				:guardian_relationship => SubjectRelationship['other'] )
			assert study_subject.errors.on_attr_and_type?(:guardian_relationship_other,:blank)
		end
	end

	test "should require guardian_relationship_other with custom message" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject(
				:guardian_relationship => SubjectRelationship['other'] )
			assert study_subject.errors.on_attr_and_type?(:guardian_relationship_other,:blank)
			assert_match /You must specify a relationship with 'other relationship' is selected/, 
				study_subject.errors.full_messages.to_sentence
			assert_no_match /Guardian relationship other/, 
				study_subject.errors.full_messages.to_sentence
		end
	end

	test "should require dob with custom message" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :dob => nil )
			assert study_subject.errors.on_attr_and_type?(:dob,:blank)
			assert_match /Date of birth can't be blank/, 
				study_subject.errors.full_messages.to_sentence
			assert_no_match /DOB/i, 
				study_subject.errors.full_messages.to_sentence
		end
	end

	test "should not require dob if subject_is_mother flag is true" do
		assert_difference('StudySubject.count',1) do
			study_subject = create_study_subject( :subject_is_mother => true, :dob => nil )
			assert study_subject.dob_not_required?
		end
	end

	test "should require dob if subject_is_mother flag is false" do
		assert_difference('StudySubject.count',0) do
			study_subject = create_study_subject( :subject_is_mother => false, :dob => nil )
			assert !study_subject.dob_not_required?
		end
	end

	test "should require birth_city if birth_country is 'United States'" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :birth_country => 'United States' )
			assert study_subject.errors.on_attr_and_type?(:birth_city,:blank)
		end
	end

	test "should require birth_state if birth_country is 'United States'" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :birth_country => 'United States' )
			assert study_subject.errors.on_attr_and_type?(:birth_state,:blank)
		end
	end

end
