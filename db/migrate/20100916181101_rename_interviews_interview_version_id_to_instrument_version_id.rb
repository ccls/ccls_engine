class RenameInterviewsInterviewVersionIdToInstrumentVersionId < SharedMigration
	def self.up
		rename_column :interviews, :interview_version_id, :instrument_version_id
	end

	def self.down
		rename_column :interviews, :instrument_version_id, :interview_version_id
	end
end
