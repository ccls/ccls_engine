class CreateInstruments < SharedMigration
	def self.up
		create_table :instruments do |t|
			t.integer :position
			t.references :project, :null => false
			t.integer :results_table_id
			t.string :code, :null => false
			t.string :name, :null => false
			t.string :description
			t.references :interview_method
			t.date :began_use_on
			t.date :ended_use_on
			t.timestamps
		end
		add_index :instruments, :project_id
		add_index :instruments, :code, :unique => true
		add_index :instruments, :description, :unique => true
	end

	def self.down
		drop_table :instruments
	end
end
