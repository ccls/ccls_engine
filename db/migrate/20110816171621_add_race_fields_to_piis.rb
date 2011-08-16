class AddRaceFieldsToPiis < SharedMigration
	def self.up
		add_column :piis, :mother_race_id, :integer
		add_column :piis, :father_race_id, :integer
	end

	def self.down
		remove_column :piis, :father_race_id
		remove_column :piis, :mother_race_id
	end
end
