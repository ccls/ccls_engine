class ChangeAddressingVerifiedByIdToVerifiedByUid < SharedMigration
	def self.up
		change_column :addressings, :verified_by_id, :string
		rename_column :addressings, :verified_by_id, :verified_by_uid
	end

	def self.down
		rename_column :addressings, :verified_by_uid, :verified_by_id
		change_column :addressings, :verified_by_id,  :integer
	end
end
