class RemoveSubjectIdFromOperationalEvents < SharedMigration
	def self.up
		remove_column :operational_events, :subject_id
	end

	def self.down
		add_column :operational_events, :subject_id, :integer
	end
end
