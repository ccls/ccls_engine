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
			t.timestamps
		end
	end

	def self.down
		drop_table :study_subjects
	end
end
