class AddOtherToSubjectRaces < SharedMigration
	def self.up
		add_column :subject_races, :other, :string
	end

	def self.down
		remove_column :subject_races, :other
	end
end
