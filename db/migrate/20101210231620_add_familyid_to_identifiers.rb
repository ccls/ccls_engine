class AddFamilyidToIdentifiers < SharedMigration
	def self.up
		add_column :identifiers, :familyid, :string, :limit => 6
	end

	def self.down
		remove_column :identifiers, :familyid
	end
end
