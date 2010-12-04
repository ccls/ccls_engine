class CreateSampleKits < SharedMigration
	def self.up
		create_table :sample_kits do |t|
			t.references :sample
			t.references :kit_package
			t.references :sample_package
			t.timestamps
		end
	end

	def self.down
		drop_table :sample_kits
	end
end
