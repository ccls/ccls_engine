class RenameCountyOfBirthToBirthCountyInCandidateControls < SharedMigration
	def self.up
		rename_column :candidate_controls, :county_of_birth, :birth_county
	end

	def self.down
		rename_column :candidate_controls, :birth_county, :county_of_birth
	end
end
