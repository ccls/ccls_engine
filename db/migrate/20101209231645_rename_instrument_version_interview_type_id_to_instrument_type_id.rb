class RenameInstrumentVersionInterviewTypeIdToInstrumentTypeId < SharedMigration
	def self.up
		rename_column :instrument_versions, :interview_type_id, :instrument_type_id
	end

	def self.down
		rename_column :instrument_versions, :instrument_type_id, :interview_type_id
	end
end
