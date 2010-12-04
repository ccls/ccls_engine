class RemoveAliquotsCountFromOrganizations < SharedMigration

	def self.up
		remove_column :organizations, :aliquots_count
	end

	def self.down
		add_column :organizations, :aliquots_count, :integer, :default => 0
	end

end
