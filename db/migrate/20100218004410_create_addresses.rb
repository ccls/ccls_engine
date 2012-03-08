class CreateAddresses < SharedMigration
	def self.up
		create_table :addresses do |t|
			t.integer :address_type_id
			t.integer :data_source_id
			t.string  :line_1
			t.string  :line_2
			t.string  :city
			t.string  :state
			t.string  :zip, :limit => 10
			t.integer :external_address_id
			t.string  :county
			t.string  :unit
			t.string  :country
			t.timestamps
		end
		add_index :addresses, :external_address_id, :unique => true
	end

	def self.down
		drop_table :addresses
	end
end
