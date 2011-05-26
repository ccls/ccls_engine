class ChangeIdentifiersPatidToString < SharedMigration
	def self.up
		change_column :identifiers, :patid, :string, :limit => 4
	end

	def self.down
		change_column :identifiers, :patid, :integer
	end
end
