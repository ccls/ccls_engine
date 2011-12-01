class CreateHomexOutcomes < SharedMigration
	def self.up
		create_table :homex_outcomes do |t|
			t.integer :position
			t.references :study_subject	#, :null => false
			t.references :sample_outcome
			t.date :sample_outcome_on
			t.references :interview_outcome
			t.date :interview_outcome_on
			t.timestamps
		end
		add_index :homex_outcomes, :study_subject_id, :unique => true
	end

	def self.down
		drop_table :homex_outcomes
	end
end
