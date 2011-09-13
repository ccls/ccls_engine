class RenameAbstractsSubjectIdToStudySubjectId < SharedMigration
	def self.up
		rename_column :abstracts, :subject_id, :study_subject_id
	end

	def self.down
		rename_column :abstracts, :study_subject_id, :subject_id
	end
end
