class CreateSubjectTypes < SharedMigration
	def self.up
		create_table :subject_types do |t|
			t.integer :position
			t.string :code, :null => false
			t.string :description
			t.string :related_case_control_type
			t.timestamps
		end
		add_index :subject_types, :code, :unique => true
		add_index :subject_types, :description, :unique => true
	end

	def self.down
		drop_table :subject_types
	end
end
