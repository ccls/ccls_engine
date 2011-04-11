class AddRetrospectiveToPatients < SharedMigration
	def self.up
		add_column :patients, :is_retrospective_case, :boolean, :default => false
	end

	def self.down
		remove_column :patients, :is_retrospective_case
	end
end
