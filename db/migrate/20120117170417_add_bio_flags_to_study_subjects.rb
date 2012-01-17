class AddBioFlagsToStudySubjects < SharedMigration
	def self.up
		add_column :study_subjects, :mom_is_biomom, :integer
		add_column :study_subjects, :dad_is_biodad, :integer
	end

	def self.down
		remove_column :study_subjects, :dad_is_biodad
		remove_column :study_subjects, :mom_is_biomom
	end
end
