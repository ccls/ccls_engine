class CreateFollowUpTypes < SharedMigration
	def self.up
		create_table :follow_up_types do |t|
			t.integer :position
			t.string :code
			t.string :description
			t.timestamps
		end
		add_index :follow_up_types, :code, :unique => true
	end

	def self.down
		drop_table :follow_up_types
	end
end
