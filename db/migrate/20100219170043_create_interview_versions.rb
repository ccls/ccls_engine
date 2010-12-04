class CreateInterviewVersions < SharedMigration
	def self.up
		create_table :interview_versions do |t|
			t.integer :position
			t.references :interview_type
			t.references :language
			t.date :began_use_on
			t.date :ended_use_on
			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :interview_versions, :code, :unique => true
		add_index :interview_versions, :description, :unique => true
	end

	def self.down
		drop_table :interview_versions
	end
end
