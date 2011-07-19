require 'test_helper'

class Ccls::CandidateControlTest < ActiveSupport::TestCase
	
	assert_should_create_default_object
	assert_should_belong_to( :subject )
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
		:county_of_birth,
		:assigned_on,
		:mother_race_id,
		:mother_hisp_id,
		:father_race_id,
		:birth_type,
		:mother_maiden_name,
		:mother_yrs_educ,
		:father_yrs_educ,
		:rejection_reason )

	assert_should_require_attribute_length( :related_patid, :is => 5 )
	assert_should_require_attribute_length( :state_registrar_no, :maximum => 25 )
	assert_should_require_attribute_length( :local_registrar_no, :maximum => 25 )
	assert_should_require_attribute_length( 
		:first_name,
		:middle_name,
		:last_name,
		:sex,
		:county_of_birth,
		:birth_type,
		:mother_maiden_name,
		:rejection_reason,
			:maximum => 250 )


#			t.integer :icf_master_id
#			t.string  :related_patid, :limit => 5
#			t.integer :study_subject_id
#			t.string  :first_name
#			t.string  :middle_name
#			t.string  :last_name
#			t.date    :dob
#			t.string  :state_registrar_no, :limit => 25
#			t.string  :local_registrar_no, :limit => 25
#			t.string  :sex
#			t.string  :county_of_birth
#			t.date    :assigned_on
#			t.integer :mother_race_id
#			t.integer :mother_hisp_id
#			t.integer :father_race_id
#			t.string  :birth_type
#			t.string  :mother_maiden_name
#			t.integer :mother_yrs_educ
#			t.integer :father_yrs_educ
#			t.boolean :reject_candidate, :null => false, :default => false
#			t.string  :rejection_reason
end
