class CreatePackages < SharedMigration
	def self.up
		create_table :packages do |t|
			t.integer :position
#			t.string :carrier, :null => false
#			t.string :tracking_number, :null => false
			t.string :status
			t.timestamps
		end
#		add_index :packages, :tracking_number, :unique => true
	end

	def self.down
		drop_table :packages
	end
end
