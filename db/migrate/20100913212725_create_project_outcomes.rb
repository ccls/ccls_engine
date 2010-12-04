class CreateProjectOutcomes < SharedMigration
	def self.up
		create_table :project_outcomes do |t|
			t.integer :position
			t.references :project
			t.string :code
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :project_outcomes
	end
end
