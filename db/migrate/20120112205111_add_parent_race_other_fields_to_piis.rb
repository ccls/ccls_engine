class AddParentRaceOtherFieldsToPiis < SharedMigration
	def self.up
		add_column :piis, :mother_race_other, :string
		add_column :piis, :father_race_other, :string
	end

	def self.down
		remove_column :piis, :father_race_other
		remove_column :piis, :mother_race_other
	end
end
