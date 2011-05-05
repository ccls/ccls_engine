class RemoveLatitudeAndLongitudeFromZipCodes < SharedMigration
	def self.up
		remove_column :zip_codes, :latitude
		remove_column :zip_codes, :longitude
	end

	def self.down
		add_column :zip_codes, :latitude,  :float, :null => false
		add_column :zip_codes, :longitude, :float, :null => false
	end
end
