class AddEventNotesToOperationalEvent < SharedMigration
	def self.up
		add_column :operational_events, :event_notes, :string
	end

	def self.down
		remove_column :operational_events, :event_notes
	end
end
