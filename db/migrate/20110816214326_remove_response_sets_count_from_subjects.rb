class RemoveResponseSetsCountFromSubjects < SharedMigration
	def self.up
		remove_column :subjects, :response_sets_count
	end

	def self.down
		add_column :subjects, :response_sets_count, :integer, :default => 0
	end
end
