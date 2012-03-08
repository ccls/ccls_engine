class CreateFollowUpTypes < SharedMigration
	def self.up
		create_table :follow_up_types do |t|
			t.integer :position
			t.string  :key, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :follow_up_types, :key, :unique => true
	end

	def self.down
		drop_table :follow_up_types
	end
end
