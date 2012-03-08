class CreateSampleTypes < SharedMigration
	def self.up
		create_table :sample_types do |t|
			t.integer :position
			t.integer :parent_id
			t.string  :key, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :sample_types, :parent_id
		add_index :sample_types, :key, :unique => true
		add_index :sample_types, :description, :unique => true
	end

	def self.down
		drop_table :sample_types
	end
end
