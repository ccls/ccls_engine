class RemoveSubjectidFromSubjects < SharedMigration
	def self.up
		remove_index  :subjects, :subjectid
		remove_column :subjects, :subjectid
	end

	def self.down
		add_column :subjects, :subjectid, :string, :limit => 6
		add_index  :subjects, :subjectid, :unique => true
	end
end
