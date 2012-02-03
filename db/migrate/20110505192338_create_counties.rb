class CreateCounties < SharedMigration
	def self.up
		create_table :counties do |t|
			t.string :name
			t.string :fips_code, :limit => 5
			t.string :state_abbrev, :limit => 2
			t.timestamps
		end
		add_index :counties, :state_abbrev
	end

	def self.down
		drop_table :counties
	end
end
