class AddPrimaryRaceIdToSubjects < SharedMigration
	def self.up
		add_column :subjects, :primary_race_id, :integer
	end

	def self.down
		remove_column :subjects, :primary_race_id
	end
end
