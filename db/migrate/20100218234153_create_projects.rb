class CreateProjects < SharedMigration
	def self.up
		create_table :projects do |t|
			t.integer :position
			t.date :began_on
			t.date :ended_on
			t.string :code, :null => false
			t.string :description
			t.text :eligibility_criteria
			t.timestamps
		end
		add_index :projects, :code, :unique => true
		add_index :projects, :description, :unique => true
	end

	def self.down
		drop_table :projects
	end
end
