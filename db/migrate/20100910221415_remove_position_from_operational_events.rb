class RemovePositionFromOperationalEvents < SharedMigration
	def self.up
		remove_column :operational_events, :position
	end

	def self.down
		add_column :operational_events, :position, :integer
	end
end
