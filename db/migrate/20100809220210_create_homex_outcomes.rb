class CreateHomexOutcomes < SharedMigration
	def self.up
		create_table :homex_outcomes do |t|
			t.integer :position
			t.integer :study_subject_id
			t.integer :sample_outcome_id
			t.date    :sample_outcome_on
			t.integer :interview_outcome_id
			t.date    :interview_outcome_on
			t.timestamps
		end
		add_index :homex_outcomes, :study_subject_id, :unique => true
	end

	def self.down
		drop_table :homex_outcomes
	end
end
