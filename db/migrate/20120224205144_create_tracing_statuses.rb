class CreateTracingStatuses < SharedMigration
	def self.up
		create_table :tracing_statuses do |t|
			t.integer :position
			t.string  :key, :null => false
			t.string  :description, :null => false
			t.timestamps
		end
		add_index :tracing_statuses, :key, :unique => true
		add_index :tracing_statuses, :description, :unique => true
	end

	def self.down
		drop_table :tracing_statuses
	end
end
