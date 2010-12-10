class RemoveMatchingidFromSubjects < SharedMigration
	def self.up
		remove_column :subjects, :matchingid
	end

	def self.down
		add_column :subjects, :matchingid, :string, :limit => 6
	end
end
