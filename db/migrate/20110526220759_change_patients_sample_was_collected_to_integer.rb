class ChangePatientsSampleWasCollectedToInteger < SharedMigration
	def self.up
		change_column :patients, :sample_was_collected, :integer
	end

	def self.down
		change_column :patients, :sample_was_collected, :boolean
	end
end
