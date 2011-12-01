class CreateOperationalEventTypes < SharedMigration
	def self.up
		create_table :operational_event_types do |t|
			t.integer :position
			t.string :code, :null => false
			t.string :description
			t.string :event_category
			t.timestamps
		end
		add_index :operational_event_types, :code, :unique => true
		add_index :operational_event_types, :description, :unique => true
	end

	def self.down
		drop_table :operational_event_types
	end
end
