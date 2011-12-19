class AddHispanicityMexFieldsToStudySubjects < SharedMigration
	def self.up
		add_column :study_subjects, :mother_hispanicity_mex, :integer
		add_column :study_subjects, :father_hispanicity_mex, :integer
	end

	def self.down
		remove_column :study_subjects, :father_hispanicity_mex
		remove_column :study_subjects, :mother_hispanicity_mex
	end
end
