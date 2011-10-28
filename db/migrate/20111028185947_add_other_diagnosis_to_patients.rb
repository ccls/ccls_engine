class AddOtherDiagnosisToPatients < SharedMigration
	def self.up
		add_column :patients, :other_diagnosis, :string
	end

	def self.down
		remove_column :patients, :other_diagnosis
	end
end
