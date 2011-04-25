class AddWasUnder15AtDxToPatients < SharedMigration
	def self.up
		add_column :patients, :was_under_15_at_dx, :boolean, :default => true
	end

	def self.down
		remove_column :patients, :was_under_15_at_dx
	end
end
