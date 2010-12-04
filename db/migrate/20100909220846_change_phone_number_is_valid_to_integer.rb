class ChangePhoneNumberIsValidToInteger < SharedMigration
	def self.up
		change_column :phone_numbers, :is_valid, :integer
	end

	def self.down
		change_column :phone_numbers, :is_valid, :boolean
	end
end
