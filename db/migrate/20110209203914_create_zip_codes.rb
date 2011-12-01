class CreateZipCodes < SharedMigration
	def self.up
		create_table :zip_codes do |t|
			t.with_options :null => false do |o|
				o.string  :zip_code, :limit => 5
				o.string  :city
				o.string  :state
				o.string  :zip_class
			end
			t.integer :county_id	#	null is ok?
			t.timestamps
		end
		add_index :zip_codes, :zip_code, :unique => true
	end

	def self.down
		drop_table :zip_codes
	end
end
