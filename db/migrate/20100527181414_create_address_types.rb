class CreateAddressTypes < SharedMigration
	def self.up
		create_table :address_types do |t|
			t.integer :position
			t.string  :key, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :address_types, :key, :unique => true
	end

	def self.down
		drop_table :address_types
	end
end
