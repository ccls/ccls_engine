class LimitAddressesZipTo10Chars < SharedMigration
	def self.up
		change_column :addresses, :zip, :string, :limit => 10
	end

	def self.down
		change_column :addresses, :zip, :string
	end
end
