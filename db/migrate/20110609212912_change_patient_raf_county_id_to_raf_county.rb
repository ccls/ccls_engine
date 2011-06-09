class ChangePatientRafCountyIdToRafCounty < SharedMigration
	def self.up
		add_column    :patients, :raf_county, :string
		remove_column :patients, :raf_county_id
	end

	def self.down
		add_column    :patients, :raf_county_id, :integer
		remove_column :patients, :raf_county
	end
end
