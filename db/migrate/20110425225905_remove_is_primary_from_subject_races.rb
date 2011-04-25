class RemoveIsPrimaryFromSubjectRaces < SharedMigration
	def self.up
		remove_column :subject_races, :is_primary
	end

	def self.down
		add_column :subject_races, :is_primary, :boolean, :default => false, :null => false
	end
end
