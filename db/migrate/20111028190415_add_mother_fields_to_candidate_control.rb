class AddMotherFieldsToCandidateControl < SharedMigration
	def self.up
		add_column :candidate_controls, :mother_first_name, :string
		add_column :candidate_controls, :mother_middle_name, :string
		add_column :candidate_controls, :mother_last_name, :string
		add_column :candidate_controls, :mother_dob, :date
	end

	def self.down
		remove_column :candidate_controls, :mother_dob
		remove_column :candidate_controls, :mother_last_name
		remove_column :candidate_controls, :mother_middle_name
		remove_column :candidate_controls, :mother_first_name
	end
end
