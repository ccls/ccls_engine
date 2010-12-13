class SetAddressingCurrentAddressDefaultToYes < SharedMigration
	def self.up
		change_column :addressings, :current_address, :integer, :default => 1
	end

	def self.down
		change_column :addressings, :current_address, :integer, :default => nil
	end
end
