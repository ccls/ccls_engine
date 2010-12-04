class AllowHomexOutcomeSubjectIdToBeNil < SharedMigration
	def self.up
		#	because I use 'accepts_nested_attributes_for :homex_outcome'
		#	the subject_id will initially be nil so I must allow it.
		change_column :homex_outcomes, :subject_id, :integer, :null => true
	end

	def self.down
		change_column :homex_outcomes, :subject_id, :integer, :null => false
	end
end
