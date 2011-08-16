class AddBirthCountyToSubjects < SharedMigration
	def self.up
		add_column :subjects, :birth_county, :string
	end

	def self.down
		remove_column :subjects, :birth_county
	end
end
