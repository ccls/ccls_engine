class CreateCandidateControls < SharedMigration
	def self.up
		create_table :candidate_controls do |t|
			t.integer :icf_master_id
			t.string  :related_patid, :limit => 5
			t.integer :study_subject_id
			t.string  :first_name
			t.string  :middle_name
			t.string  :last_name
			t.date    :dob
			t.string  :state_registrar_no, :limit => 25
			t.string  :local_registrar_no, :limit => 25
			t.string  :sex
			t.string  :birth_county
			t.date    :assigned_on
			t.integer :mother_race_id
			t.integer :mother_hispanicity_id
			t.integer :father_race_id
			t.integer :father_hispanicity_id
			t.string  :birth_type
			t.string  :mother_maiden_name
			t.integer :mother_yrs_educ
			t.integer :father_yrs_educ
			t.boolean :reject_candidate, :null => false, :default => false
			t.string  :rejection_reason
			t.string  :mother_first_name
			t.string  :mother_middle_name
			t.string  :mother_last_name
			t.date    :mother_dob
			t.integer :mom_is_biomom
			t.integer :dad_is_biodad
			t.timestamps
		end
	end

	def self.down
		drop_table :candidate_controls
	end
end
