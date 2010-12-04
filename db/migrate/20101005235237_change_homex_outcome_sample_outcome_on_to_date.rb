class ChangeHomexOutcomeSampleOutcomeOnToDate < SharedMigration
	def self.up
		change_column :homex_outcomes, :sample_outcome_on, :date
	end

	def self.down
		change_column :homex_outcomes, :sample_outcome_on, :datetime
	end
end
