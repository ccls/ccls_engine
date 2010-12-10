class AddMatchingidToIdentifiers < SharedMigration
	def self.up
		add_column :identifiers, :matchingid, :string, :limit => 6
	end

	def self.down
		remove_column :identifiers, :matchingid
	end
end
