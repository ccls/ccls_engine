class AddPrimaryContactIdToOrganizations < SharedMigration

	def self.up
		add_column :organizations, :primary_contact_id, :integer
	end

	def self.down
		remove_column :organizations, :primary_contact_id
	end

end
