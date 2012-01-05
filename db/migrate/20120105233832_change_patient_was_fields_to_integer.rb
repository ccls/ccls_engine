class ChangePatientWasFieldsToInteger < SharedMigration
	def self.up
		change_column :patients, :was_ca_resident_at_diagnosis, :integer
		change_column :patients, :was_previously_treated, :integer
		change_column :patients, :was_under_15_at_dx, :integer
	end

	def self.down
		change_column :patients, :was_ca_resident_at_diagnosis, :boolean
		change_column :patients, :was_previously_treated, :boolean
		change_column :patients, :was_under_15_at_dx, :boolean
	end
end
