class RemoveProjectIdFromOperationalEventTypes < SharedMigration
	def self.up
		remove_column :operational_event_types, :project_id
	end

	def self.down
		add_column :operational_event_types, :project_id, :integer
	end
end
