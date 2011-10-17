class RemoveHospitalNoUniqueIndex < SharedMigration
	def self.up
		remove_index :identifiers, :hospital_no
	end

	def self.down
		add_index :identifiers, :hospital_no, :unique => true
	end
end
