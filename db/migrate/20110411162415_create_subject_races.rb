class CreateSubjectRaces < SharedMigration
	def self.up
		create_table :subject_races do |t|
			t.integer :study_subject_id
			t.integer :race_id
			t.boolean :primary, :default => false, :null => false
			t.timestamps
		end
	end

	def self.down
		drop_table :subject_races
	end
end
