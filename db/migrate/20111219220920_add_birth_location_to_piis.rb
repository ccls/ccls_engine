class AddBirthLocationToPiis < SharedMigration
	def self.up
		add_column :piis, :birth_city, :string
		add_column :piis, :birth_state, :string
		add_column :piis, :birth_country, :string
	end

	def self.down
		remove_column :piis, :birth_country
		remove_column :piis, :birth_state
		remove_column :piis, :birth_city
	end
end
