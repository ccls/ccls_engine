class RemoveRaceIdFromSubjects < SharedMigration
	def self.up
		remove_column :subjects, :race_id
	end

	def self.down
		add_column :subjects, :race_id, :integer
	end
end
