class CreateProjectOutcomes < SharedMigration
	def self.up
		create_table :project_outcomes do |t|
			t.integer :position
			t.integer :project_id
			t.string  :key, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :project_outcomes, :key, :unique => true
	end

	def self.down
		drop_table :project_outcomes
	end
end
