class AddCountyToAddresses < SharedMigration
	def self.up
		add_column :addresses, :county, :string
	end

	def self.down
		remove_column :addresses, :county
	end
end
