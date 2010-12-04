class CreateUnits < SharedMigration
	def self.up
		create_table :units do |t|
			t.integer :position
			t.references :context
			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :units, :code, :unique => true
		add_index :units, :description, :unique => true
	end

	def self.down
		drop_table :units
	end
end
