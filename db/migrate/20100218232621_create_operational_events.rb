class CreateOperationalEvents < SharedMigration
	def self.up
		create_table :operational_events do |t|
			t.integer :position
			t.references :subject
			t.references :operational_event_type
			t.date :began_on
			t.date :completed_on
			t.date :sent_on
			t.date :received_on
			t.timestamps
		end
	end

	def self.down
		drop_table :operational_events
	end
end
