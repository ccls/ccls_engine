require 'test_helper'

class Ccls::PiiTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_initially_belong_to(:study_subject)
	assert_should_protect( :study_subject_id )

	assert_should_belong_to( :guardian_relationship, :class_name => 'SubjectRelationship' )
	assert_should_require_attributes( :dob )
	assert_should_require_unique_attributes( :email )
	assert_should_not_require_attributes( :first_name, :last_name,
		:died_on, :birth_year,
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

	assert_should_require_attribute_length( :generational_suffix, :maximum => 10 )
	assert_should_require_attribute_length( :father_generational_suffix, :maximum => 10 )
	assert_should_require_attribute_length( :birth_year, :maximum => 4 )
	assert_requires_complete_date( :dob )
	assert_requires_complete_date( :died_on )

	%w( email first_name middle_name last_name 
		father_first_name father_middle_name father_last_name
		mother_first_name mother_middle_name 
		mother_maiden_name mother_last_name 
		guardian_first_name guardian_middle_name 
		guardian_last_name ).each do |field|
		test "should nullify blank #{field}" do
			assert_difference("Pii.count",1) do
				pii = create_pii(field => ' ')
				assert_nil pii.reload.send(field)
			end
		end
	end

	test "should allow multiple blank email" do
		create_pii(:email => '  ')
		assert_difference( "Pii.count", 1 ) do
			pii = create_pii(:email => ' ')
		end
	end

	test "should require properly formated email address" do
		assert_difference( "Pii.count", 0 ) do
			%w( asdf me@some@where.com me@somewhere ).each do |bad_email|
				pii = create_pii(:email => bad_email)
				assert pii.errors.on_attr_and_type(:email,:invalid)
			end
		end
		assert_difference( "Pii.count", 1 ) do
			%w( me@some.where.com ).each do |good_email|
				pii = create_pii(:email => good_email)
				assert !pii.errors.on_attr_and_type(:email,:invalid)
			end
		end
	end

	test "should return dob as a date NOT time" do
		pii = create_pii
		assert_changes("Pii.find(#{pii.id}).dob") {
			pii.update_attribute(:dob, Chronic.parse('tomorrow at noon'))
		}
		assert !pii.new_record?
		assert_not_nil pii.dob
		assert pii.dob.is_a?(Date)
		assert_equal pii.dob, pii.dob.to_date
	end

	test "should parse a properly formatted date" do
		#	Chronic won't parse this correctly,
		#	but Date.parse will. ???
		assert_difference( "Pii.count", 1 ) do
			pii = create_pii(
				:dob => Chronic.parse("January 1 2001"))
			assert !pii.new_record?, 
				"#{pii.errors.full_messages.to_sentence}"
		end
	end

	test "should return join of study_subject's initials" do
		pii = create_pii(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'JS', pii.initials 
	end

	test "should return join of study_subject's name" do
		pii = create_pii(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'John Smith', pii.full_name 
	end

	test "should return 'name not available' if study_subject's names are blank" do
		pii = create_pii
		assert_equal '[name not available]', pii.full_name 
	end

	test "should return 'name not available' if study_subject's father's names are blank" do
		pii = create_pii
		assert_equal '[name not available]', pii.fathers_name
	end

	test "should return 'name not available' if study_subject's mother's names are blank" do
		pii = create_pii
		assert_equal '[name not available]', pii.mothers_name
	end

	test "should return 'name not available' if study_subject's guardian's names are blank" do
		pii = create_pii
		assert_equal '[name not available]', pii.guardians_name
	end

	test "should return join of father's name" do
		pii = create_pii(
			:father_first_name => "Santa",
			:father_last_name => "Claus" )
		assert_equal 'Santa Claus', pii.fathers_name 
	end

	test "should return join of mother's name" do
		pii = create_pii(
			:mother_first_name => "Ms",
			:mother_last_name => "Claus" )
		assert_equal 'Ms Claus', pii.mothers_name 
	end

	test "should return join of guardian's name" do
		pii = create_pii(
			:guardian_first_name => "Jack",
			:guardian_last_name => "Frost" )
		assert_equal 'Jack Frost', pii.guardians_name 
	end

	test "should require guardian_relationship_other if " <<
			"guardian_relationship == other" do
		assert_difference( "Pii.count", 0 ) do
			pii = create_pii(
				:guardian_relationship => SubjectRelationship['other'] )
			assert pii.errors.on_attr_and_type(:guardian_relationship_other,:blank)
		end
	end

	test "should not require dob if subject_is_mother flag is true" do
		assert_difference('Pii.count',1) do
			pii = create_pii( :subject_is_mother => true, :dob => nil )
			assert pii.dob_not_required?
		end
	end

	test "should require dob if subject_is_mother flag is false" do
		assert_difference('Pii.count',0) do
			pii = create_pii( :subject_is_mother => false, :dob => nil )
			assert !pii.dob_not_required?
		end
	end

	test "should not require dob if subject_is_father flag is true" do
		assert_difference('Pii.count',1) do
			pii = create_pii( :subject_is_father => true, :dob => nil )
			assert pii.dob_not_required?
		end
	end

	test "should require dob if subject_is_father flag is false" do
		assert_difference('Pii.count',0) do
			pii = create_pii( :subject_is_father => false, :dob => nil )
			assert !pii.dob_not_required?
		end
	end

protected

	def create_pii(options={})
		pii = Factory.build(:pii,options)
		pii.save
		pii
	end

end
