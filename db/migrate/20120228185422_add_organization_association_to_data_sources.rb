class AddOrganizationAssociationToDataSources < SharedMigration
	def self.up
		add_column :data_sources, :organization_id, :integer
		add_column :data_sources, :other_organization, :string
	end

	def self.down
		remove_column :data_sources, :organization_id
		remove_column :data_sources, :other_organization
	end
end
