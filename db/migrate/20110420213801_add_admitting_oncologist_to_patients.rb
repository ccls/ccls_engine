class AddAdmittingOncologistToPatients < SharedMigration
	def self.up
		add_column :patients, :admitting_oncologist, :string
	end

	def self.down
		remove_column :patients, :admitting_oncologist
	end
end
