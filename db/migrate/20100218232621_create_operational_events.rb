class CreateOperationalEvents < SharedMigration
	def self.up
		create_table :operational_events do |t|
			t.references :operational_event_type
			t.date    :occurred_on
			t.integer :enrollment_id
			t.string  :description
			t.text    :event_notes
			t.timestamps
		end
	end

	def self.down
		drop_table :operational_events
	end
end
