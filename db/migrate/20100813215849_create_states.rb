class CreateStates < SharedMigration
	def self.up
		create_table :states do |t|
			t.integer :position
			t.string  :code, :null => false
			t.string  :name, :null => false
			t.string  :fips_country_code, :limit => 2, :null => false
			t.string  :fips_state_code, :limit => 2, :null => false
			t.timestamps
		end
		add_index :states, :code, :unique => true
		add_index :states, :name, :unique => true
		add_index :states, :fips_country_code
		add_index :states, :fips_state_code, :unique => true
	end

	def self.down
		drop_table :states
	end
end
