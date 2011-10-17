class ChangePhoneNumberVerifiedByIdToVerifiedByUid < SharedMigration
	def self.up
		change_column :phone_numbers, :verified_by_id, :string
		rename_column :phone_numbers, :verified_by_id, :verified_by_uid
	end

	def self.down
		rename_column :phone_numbers, :verified_by_uid, :verified_by_id
		change_column :phone_numbers, :verified_by_id,  :integer
	end
end
