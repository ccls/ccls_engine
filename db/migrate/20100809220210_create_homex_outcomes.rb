class CreateHomexOutcomes < SharedMigration
	def self.up
		create_table :homex_outcomes do |t|
			t.integer :position
			t.references :subject, :null => false
			t.references :sample_outcome
			t.datetime :sample_outcome_on
			t.references :interview_outcome
			t.datetime :interview_outcome_on
			t.timestamps
		end
		add_index :homex_outcomes, :subject_id, :unique => true
	end

	def self.down
		drop_table :homex_outcomes
	end
end
