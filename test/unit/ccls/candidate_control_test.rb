require 'test_helper'

class Ccls::CandidateControlTest < ActiveSupport::TestCase
	
	assert_should_create_default_object
	assert_should_belong_to( :study_subject )
#	need to add test for this with booleans
#	assert_should_require_attributes( :reject_candidate )
##	assert_should_require_unique_attributes( :key, :code, :description )
	assert_should_not_require_attributes( 
		:icf_master_id,
		:related_patid,
		:first_name,
		:middle_name,
		:last_name,
		:dob,
		:state_registrar_no,
		:local_registrar_no,
		:sex,
		:birth_county,
		:assigned_on,
		:mother_race_id,
		:mother_hispanicity_id,
		:father_race_id,
		:father_hispanicity_id,
		:birth_type,
		:mother_maiden_name,
		:mother_yrs_educ,
		:father_yrs_educ,
		:rejection_reason )

#	Why 5?
#	assert_should_require_attribute_length( :related_patid, :is => 5 )
	assert_should_require_attribute_length( :related_patid, :is => 4 )

	assert_should_require_attribute_length( :state_registrar_no, :maximum => 25 )
	assert_should_require_attribute_length( :local_registrar_no, :maximum => 25 )
	assert_should_require_attribute_length( 
		:first_name,
		:middle_name,
		:last_name,
		:sex,
		:birth_county,
		:birth_type,
		:mother_maiden_name,
		:rejection_reason,
			:maximum => 250 )

	test "should require rejection_reason if reject_candidate is true" do
		assert_difference("#{model_name}.count",0) {
			object = create_object(
				:reject_candidate => true,
				:rejection_reason => nil)
			assert object.errors.on_attr_and_type(:rejection_reason,:blank)
		}
	end

	test "should not require rejection_reason if reject_candidate is false" do
		assert_difference("#{model_name}.count",1) {
			object = create_object(
				:reject_candidate => false,
				:rejection_reason => nil)
		}
	end

	test "should require reject_candidate is not nil" do
		assert_difference("#{model_name}.count",0) {
			object = create_object(:reject_candidate => nil)
			assert object.errors.on_attr_and_type(:reject_candidate,:inclusion)
		}
	end

end
