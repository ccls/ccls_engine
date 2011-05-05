class RemoveCountyFromZipCodes < SharedMigration
	def self.up
		remove_column :zip_codes, :county
	end

	def self.down
		add_column :zip_codes, :county, :string, :null => false
	end
end
