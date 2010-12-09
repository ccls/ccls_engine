class RenameInterviewTypeToInstrumentType < SharedMigration
	def self.up
		rename_table :interview_types, :instrument_types
	end

	def self.down
		rename_table :instrument_types, :interview_types
	end
end
