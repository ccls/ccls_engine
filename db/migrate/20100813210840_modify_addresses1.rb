class ModifyAddresses1 < SharedMigration
	def self.up
		change_column :addresses, :is_current, :integer
		change_column :addresses, :is_address_at_diagnosis, :integer
		rename_column :addresses, :is_current, :current_address
		rename_column :addresses, :is_address_at_diagnosis, :address_at_diagnosis
	end

	def self.down
		rename_column :addresses, :current_address, :is_current
		rename_column :addresses, :address_at_diagnosis, :is_address_at_diagnosis
		change_column :addresses, :is_current, :boolean
		change_column :addresses, :is_address_at_diagnosis, :boolean
	end
end
