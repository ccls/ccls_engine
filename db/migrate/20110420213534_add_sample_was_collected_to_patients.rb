class AddSampleWasCollectedToPatients < SharedMigration
	def self.up
		add_column :patients, :sample_was_collected, :boolean
	end

	def self.down
		remove_column :patients, :sample_was_collected
	end
end
