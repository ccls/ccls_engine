class AddBirthTypeToSubjects < SharedMigration
	def self.up
		add_column :subjects, :birth_type, :string
	end

	def self.down
		remove_column :subjects, :birth_type
	end
end
