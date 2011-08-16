class AddHispanicityFieldsToSubjects < SharedMigration
	def self.up
		add_column :subjects, :mother_hispanicity_id, :integer
		add_column :subjects, :father_hispanicity_id, :integer
	end

	def self.down
		remove_column :subjects, :father_hispanicity_id
		remove_column :subjects, :mother_hispanicity_id
	end
end
