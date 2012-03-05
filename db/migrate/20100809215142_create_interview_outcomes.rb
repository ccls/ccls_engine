class CreateInterviewOutcomes < SharedMigration
	def self.up
		create_table :interview_outcomes do |t|
			t.integer :position
			t.string :key, :null => false
#			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :interview_outcomes, :key, :unique => true
#		add_index :interview_outcomes, :code, :unique => true
	end

	def self.down
		drop_table :interview_outcomes
	end
end
