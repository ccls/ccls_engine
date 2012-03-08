class CreateInstruments < SharedMigration
	def self.up
		create_table :instruments do |t|
			t.integer :position
			t.integer :project_id, :null => true
			t.integer :results_table_id
			t.string  :key, :null => false
			t.string  :name, :null => false
			t.string  :description
			t.integer :interview_method_id
			t.date    :began_use_on
			t.date    :ended_use_on
			t.timestamps
		end
		add_index :instruments, :project_id
		add_index :instruments, :key, :unique => true
		add_index :instruments, :description, :unique => true
	end

	def self.down
		drop_table :instruments
	end
end
