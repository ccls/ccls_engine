class AddStateAbbrevIndexToCounties < SharedMigration
	def self.up
		add_index :counties, :state_abbrev
	end

	def self.down
		remove_index :counties, :state_abbrev
	end
end
