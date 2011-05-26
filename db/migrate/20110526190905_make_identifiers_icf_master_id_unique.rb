class MakeIdentifiersIcfMasterIdUnique < SharedMigration
	def self.up
		add_index :identifiers, :icf_master_id, :unique => true
	end

	def self.down
		remove_index :identifiers, :icf_master_id
	end
end
