class CreateProjectOutcomes < SharedMigration
	def self.up
		create_table :project_outcomes do |t|
			t.integer :position
			t.references :project
			t.string :key, :null => false
			t.string :code, :null => false	#	actually has a numeric value
			t.string :description
			t.timestamps
		end
		add_index :project_outcomes, :key, :unique => true
		add_index :project_outcomes, :code, :unique => true
	end

	def self.down
		drop_table :project_outcomes
	end
end
