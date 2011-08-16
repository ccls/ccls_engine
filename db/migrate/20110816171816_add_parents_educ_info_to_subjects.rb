class AddParentsEducInfoToSubjects < SharedMigration
	def self.up
		add_column :subjects, :mother_yrs_educ, :integer
		add_column :subjects, :father_yrs_educ, :integer
	end

	def self.down
		remove_column :subjects, :father_yrs_educ
		remove_column :subjects, :mother_yrs_educ
	end
end
