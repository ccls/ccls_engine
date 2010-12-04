class RemovePhoneNumbersFromPii < SharedMigration
	def self.up
		remove_column :piis, :phone_primary
		remove_column :piis, :phone_alternate
		remove_column :piis, :phone_alternate_2
		remove_column :piis, :phone_alternate_3
	end

	def self.down
		add_column :piis, :phone_primary,     :string
		add_column :piis, :phone_alternate,   :string
		add_column :piis, :phone_alternate_2, :string
		add_column :piis, :phone_alternate_3, :string
	end
end
