class RemoveCompletedOnFromOperationalEvents < SharedMigration
	def self.up
		remove_column :operational_events, :completed_on
	end

	def self.down
		add_column :operational_events, :completed_on, :date
	end
end
