class AddOrganizationIdToPeople < SharedMigration
	def self.up
		add_column :people, :organization_id, :integer
	end

	def self.down
		remove_column :people, :organization_id
	end
end
