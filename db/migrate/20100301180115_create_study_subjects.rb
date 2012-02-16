class CreateStudySubjects < SharedMigration
	def self.up
		create_table :study_subjects do |t|
			t.references :subject_type

			# 1 = VitalStatus['living']
			t.integer :vital_status_id, :default => 1

			t.references :hispanicity
			t.date :reference_date
			t.string :sex
			t.boolean :do_not_contact, :default => false, :null => false
			t.integer :abstracts_count, :default => 0
			t.integer :mother_yrs_educ
			t.integer :father_yrs_educ
			t.string  :birth_type
			t.integer :mother_hispanicity_id
			t.integer :father_hispanicity_id
			t.string  :birth_county
			t.string  :is_duplicate_of, :limit => 6
			t.integer :mother_hispanicity_mex
			t.integer :father_hispanicity_mex
			t.integer :mom_is_biomom
			t.integer :dad_is_biodad

			#	Formerly pii fields
			t.string :first_name
			t.string :middle_name
			t.string :last_name
			t.date :dob
			t.date :died_on
			t.string  :mother_first_name
			t.string  :mother_middle_name
			t.string  :mother_maiden_name
			t.string  :mother_last_name
			t.string  :father_first_name
			t.string  :father_middle_name
			t.string  :father_last_name
			t.string  :email
			t.string  :guardian_first_name
			t.string  :guardian_middle_name
			t.string  :guardian_last_name
			t.integer :guardian_relationship_id
			t.string  :guardian_relationship_other
			t.integer :mother_race_id
			t.integer :father_race_id
			t.string  :maiden_name
			t.string  :generational_suffix, :limit => 10
			t.string  :father_generational_suffix, :limit => 10
			t.string  :birth_year, :limit => 4
			t.string  :birth_city
			t.string  :birth_state
			t.string  :birth_country
			t.string  :mother_race_other
			t.string  :father_race_other
			t.timestamps
		end
		add_index :study_subjects, :email, :unique => true
	end

	def self.down
		drop_table :study_subjects
	end
end
