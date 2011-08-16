class CorrectHispanicityFieldsInCandidateControls < SharedMigration
	def self.up
		add_column    :candidate_controls, :father_hispanicity_id, :integer
		rename_column :candidate_controls, :mother_hisp_id, :mother_hispanicity_id
	end

	def self.down
		rename_column :candidate_controls, :mother_hispanicity_id, :mother_hisp_id
		remove_column :candidate_controls, :father_hispanicity_id
	end
end
