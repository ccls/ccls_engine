class ChangeSubjectidToStudySubjectIdInIcfMasterIds < SharedMigration
	def self.up
		add_column    :icf_master_ids, :study_subject_id, :integer
		add_index     :icf_master_ids, :study_subject_id, :unique => true
		remove_index  :icf_master_ids, :subjectid
		remove_column :icf_master_ids, :subjectid
	end

	def self.down
		add_column    :icf_master_ids, :subjectid, :string, :limit => 6
		add_index     :icf_master_ids, :subjectid, :unique => true
		remove_index  :icf_master_ids, :study_subject_id
		remove_column :icf_master_ids, :study_subject_id
	end
end
