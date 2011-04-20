class MoveHospitalNoFromPatientsToIdentifiers < SharedMigration
	def self.up
		remove_column :patients,    :hospital_no
		add_column    :identifiers, :hospital_no, :integer
	end

	def self.down
		remove_column :identifiers, :hospital_no
		add_column    :patients,    :hospital_no, :integer
	end
end
