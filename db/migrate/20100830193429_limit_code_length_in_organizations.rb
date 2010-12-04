class LimitCodeLengthInOrganizations < SharedMigration

	def self.up
		change_column :organizations, :code, :string, :limit => 15
	end

	def self.down
		change_column :organizations, :code, :string
	end

end
