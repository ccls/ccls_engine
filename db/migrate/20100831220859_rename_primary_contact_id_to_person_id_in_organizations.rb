class RenamePrimaryContactIdToPersonIdInOrganizations < SharedMigration
	def self.up
		rename_column :organizations, :primary_contact_id, :person_id
	end

	def self.down
		rename_column :organizations, :person_id, :primary_contact_id
	end
end
