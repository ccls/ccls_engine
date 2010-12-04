class AddInstrumentIdToInstrumentVersion < SharedMigration
	def self.up
		add_column :instrument_versions, :instrument_id, :integer
	end

	def self.down
		remove_column :instrument_versions, :instrument_id
	end
end
