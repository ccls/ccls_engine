class ReplaceIdentifierIdWithStudySubjectIdInInterviews < SharedMigration
	def self.up
		remove_column :interviews, :identifier_id
		add_column    :interviews, :study_subject_id, :integer
		add_index     :interviews, :study_subject_id
	end

	def self.down
		remove_index  :interviews, :study_subject_id
		remove_column :interviews, :study_subject_id
		add_column    :interviews, :identifier_id, :integer
	end
end
