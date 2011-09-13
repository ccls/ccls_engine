class CandidateControl < Shared
	belongs_to :study_subject

#	validates_presence_of   :key, :code, :description
#	validates_presence_of   :reject_candidate	#	fails if value is actually false
	validates_inclusion_of  :reject_candidate, :in => [true, false]
#	validates_uniqueness_of :key, :code, :description
	validates_length_of     :related_patid, :is => 5, :allow_blank => true
	validates_length_of     :state_registrar_no, :local_registrar_no, 
		:maximum => 25, :allow_blank => true
	#	NEED :allow_blank => true or fails validation and says it too long (even when blank)

	validates_length_of     :first_name, :middle_name, :last_name,
		:sex, :birth_county, :birth_type, :mother_maiden_name,
		:rejection_reason, :maximum => 250, :allow_blank => true
	#	NEED :allow_blank => true or fails validation and says it too long (even when blank)

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
#			t.string  :birth_county
#			t.date    :assigned_on
#			t.integer :mother_race_id
#			t.integer :mother_hispanicity_id
#			t.integer :father_hispanicity_id
#			t.integer :father_race_id
#			t.string  :birth_type
#			t.string  :mother_maiden_name
#			t.integer :mother_yrs_educ
#			t.integer :father_yrs_educ
#			t.boolean :reject_candidate, :null => false, :default => false
#			t.string  :rejection_reason
end
