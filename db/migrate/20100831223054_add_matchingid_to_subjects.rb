class AddMatchingidToSubjects < SharedMigration
	def self.up
		add_column :subjects, :matchingid, :string, :limit => 6
		add_index  :subjects, :matchingid, :unique => true
	end

	def self.down
		remove_index  :subjects, :matchingid
		remove_column :subjects, :matchingid
	end
end
