class CreateSampleKits < SharedMigration
	def self.up
		create_table :sample_kits do |t|
			t.integer :sample_id
#	this is kinda pointless without packages.
#			t.integer :kit_package_id
#			t.integer :sample_package_id
			t.timestamps
		end
	end

	def self.down
		drop_table :sample_kits
	end
end
