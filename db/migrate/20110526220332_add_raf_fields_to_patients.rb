class AddRafFieldsToPatients < SharedMigration
	def self.up
		add_column :patients, :raf_zip,       :string, :limit => 10
		add_column :patients, :raf_county_id, :integer
	end

	def self.down
		remove_column :patients, :raf_county_id
		remove_column :patients, :raf_zip
	end
end
