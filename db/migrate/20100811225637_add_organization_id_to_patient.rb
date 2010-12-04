class AddOrganizationIdToPatient < SharedMigration
	def self.up
		add_column :patients, :organization_id, :integer
		add_index  :patients, :organization_id
	end

	def self.down
		remove_index  :patients, :organization_id
		remove_column :patients, :organization_id
	end
end
