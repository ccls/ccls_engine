class AddUnitToAddresses < SharedMigration
	def self.up
		add_column :addresses, :unit, :string
	end

	def self.down
		remove_column :addresses, :unit
	end
end
