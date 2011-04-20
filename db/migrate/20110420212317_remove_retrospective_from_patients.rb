class RemoveRetrospectiveFromPatients < SharedMigration
	def self.up
		remove_column :patients, :is_retrospective_case
	end

	def self.down
		add_column :patients, :is_retrospective_case, :boolean, :default => false
	end
end
