class RedefineHospitalNoToString < SharedMigration
	def self.up
		change_column :identifiers, :hospital_no, :string, :limit => 25
	end

	def self.down
		change_column :identifiers, :hospital_no, :integer
	end
end
