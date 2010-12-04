class AddEnrollmentIdToOperationalEvents < SharedMigration
	def self.up
		add_column :operational_events, :enrollment_id, :integer
	end

	def self.down
		remove_column :operational_events, :enrollment_id
	end
end
