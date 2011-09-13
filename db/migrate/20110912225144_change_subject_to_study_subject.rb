class ChangeSubjectToStudySubject < SharedMigration
	def self.up
		rename_table :subjects, :study_subjects
	end

	def self.down
		rename_table :study_subjects, :subjects
	end
end
