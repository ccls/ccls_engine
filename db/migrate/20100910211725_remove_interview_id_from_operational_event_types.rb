class RemoveInterviewIdFromOperationalEventTypes < SharedMigration
	def self.up
		remove_column :operational_event_types, :interview_id
	end

	def self.down
		add_column :operational_event_types, :interview_id, :integer
	end
end
