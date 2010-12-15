class AddCurrentPhoneToPhoneNumbers < SharedMigration
	def self.up
		add_column :phone_numbers, :current_phone, :integer, :default => 1
	end

	def self.down
		remove_column :phone_numbers, :current_phone
	end
end
