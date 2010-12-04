class CreateTransfers < SharedMigration
	def self.up
		create_table :transfers do |t|
			t.integer :position
			t.references :aliquot
			t.integer :from_organization_id, :null => false
			t.integer :to_organization_id, :null => false
			t.decimal :amount
			t.string :reason
			t.boolean :is_permanent
			t.timestamps
		end
		add_index :transfers, :aliquot_id
		add_index :transfers, :from_organization_id
		add_index :transfers, :to_organization_id
	end

	def self.down
		drop_table :transfers
	end
end
