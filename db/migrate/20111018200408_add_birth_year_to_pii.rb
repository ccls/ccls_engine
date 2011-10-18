class AddBirthYearToPii < SharedMigration
	def self.up
		add_column :piis, :birth_year, :string, :limit => 4
	end

	def self.down
		remove_column :piis, :birth_year
	end
end
