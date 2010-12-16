class AddCollectedOnToSamples < SharedMigration
	def self.up
		add_column :samples, :collected_on, :date
	end

	def self.down
		remove_column :samples, :collected_on
	end
end
