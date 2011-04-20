class AddWasPreviouslyTreatedToPatients < SharedMigration
	def self.up
		add_column :patients, :was_previously_treated, :boolean, :default => false
	end

	def self.down
		remove_column :patients, :was_previously_treated
	end
end
