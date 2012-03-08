class CreateUnits < SharedMigration
	def self.up
		create_table :units do |t|
			t.integer :position
			t.integer :context_id
			t.string  :key, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :units, :key, :unique => true
		add_index :units, :description, :unique => true
	end

	def self.down
		drop_table :units
	end
end
