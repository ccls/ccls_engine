class AddBioFlagsToCandidateControls < SharedMigration
	def self.up
		add_column :candidate_controls, :mom_is_biomom, :integer
		add_column :candidate_controls, :dad_is_biodad, :integer
	end

	def self.down
		remove_column :candidate_controls, :dad_is_biodad
		remove_column :candidate_controls, :mom_is_biomom
	end
end
