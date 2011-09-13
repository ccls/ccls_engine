class ChangeAnalysesSubjectsToAnalysesStudySubjects < SharedMigration
	def self.up
		rename_table :analyses_subjects, :analyses_study_subjects
	end

	def self.down
		rename_table :analyses_study_subjects, :analyses_subjects
	end
end
