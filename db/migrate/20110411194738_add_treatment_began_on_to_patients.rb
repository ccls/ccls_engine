class AddTreatmentBeganOnToPatients < SharedMigration
	def self.up
		add_column :patients, :treatment_began_on, :date
	end

	def self.down
		remove_column :patients, :treatment_began_on
	end
end
