class AddCountyIdToZipCodes < SharedMigration
	def self.up
		add_column :zip_codes, :county_id, :integer
	end

	def self.down
		remove_column :zip_codes, :county_id
	end
end
