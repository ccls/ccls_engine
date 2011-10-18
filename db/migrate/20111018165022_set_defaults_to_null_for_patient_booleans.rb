class SetDefaultsToNullForPatientBooleans < SharedMigration
	def self.up
		change_column :patients, :was_ca_resident_at_diagnosis, :boolean, :default => nil
		change_column :patients, :was_previously_treated, :boolean, :default => nil
		change_column :patients, :was_under_15_at_dx, :boolean, :default => nil
	end

	def self.down
		change_column :patients, :was_ca_resident_at_diagnosis, :boolean, :default => true
		change_column :patients, :was_previously_treated, :boolean, :default => false
		change_column :patients, :was_under_15_at_dx, :boolean, :default => true
	end
end
