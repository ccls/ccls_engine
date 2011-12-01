class CreateDiagnoses < SharedMigration
	def self.up
		create_table :diagnoses do |t|
			t.integer :position
			t.string  :key
			t.integer :code, :null => false
			t.string  :description, :null => false
			t.timestamps
		end
		add_index	:diagnoses, :key, :unique => true
		add_index :diagnoses, :code, :unique => true
		add_index :diagnoses, :description, :unique => true
	end

	def self.down
		drop_table :diagnoses
	end
end
