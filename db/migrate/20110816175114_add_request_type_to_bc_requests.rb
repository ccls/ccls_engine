class AddRequestTypeToBcRequests < SharedMigration
	def self.up
		add_column :bc_requests, :request_type, :string
	end

	def self.down
		remove_column :bc_requests, :request_type
	end
end
