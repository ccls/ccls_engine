class CreateInterviewTypes < SharedMigration
	def self.up
		create_table :interview_types do |t|
			t.integer :position
			t.references :project
			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :interview_types, :code, :unique => true
		add_index :interview_types, :description, :unique => true
	end

	def self.down
		drop_table :interview_types
	end
end
