class CreatePiis < SharedMigration
	def self.up
#		create_table :piis do |t|
#			t.references :study_subject
#			t.string :first_name
#			t.string :middle_name
#			t.string :last_name
#			t.date :dob
#			t.date :died_on
#			t.string  :mother_first_name
#			t.string  :mother_middle_name
#			t.string  :mother_maiden_name
#			t.string  :mother_last_name
#			t.string  :father_first_name
#			t.string  :father_middle_name
#			t.string  :father_last_name
#			t.string  :email
#			t.string  :guardian_first_name
#			t.string  :guardian_middle_name
#			t.string  :guardian_last_name
#			t.integer :guardian_relationship_id
#			t.string  :guardian_relationship_other
#			t.integer :mother_race_id
#			t.integer :father_race_id
#			t.string  :maiden_name
#			t.string  :generational_suffix, :limit => 10
#			t.string  :father_generational_suffix, :limit => 10
#			t.string  :birth_year, :limit => 4
#			t.string  :birth_city
#			t.string  :birth_state
#			t.string  :birth_country
#			t.string  :mother_race_other
#			t.string  :father_race_other
#			t.timestamps
#		end
#		add_index :piis, :email, :unique => true
#		add_index :piis, :study_subject_id, :unique => true
	end

	def self.down
#		drop_table :piis
	end
end
