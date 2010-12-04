class CreateVitalStatuses < SharedMigration
	def self.up
		create_table :vital_statuses do |t|
			t.integer :position
			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :vital_statuses, :code, :unique => true
	end

	def self.down
		drop_table :vital_statuses
	end
end
