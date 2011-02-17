class AddAdmitDateToPatients < SharedMigration
	def self.up
		add_column :patients, :admit_date, :date
	end

	def self.down
		remove_column :patients, :admit_date
	end
end
