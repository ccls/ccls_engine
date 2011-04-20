class AddWasCaResidentAtDiagnosisToPatients < SharedMigration
	def self.up
		add_column :patients, :was_ca_resident_at_diagnosis, :boolean, :default => true
	end

	def self.down
		remove_column :patients, :was_ca_resident_at_diagnosis
	end
end
