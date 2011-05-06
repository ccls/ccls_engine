class AddTimeFieldsForBeganAndEndedToInterviews < SharedMigration
	def self.up
		add_column :interviews, :began_at, :datetime
		add_column :interviews, :began_at_hour, :integer
		add_column :interviews, :began_at_minute, :integer
		add_column :interviews, :began_at_meridiem, :string
		add_column :interviews, :ended_at, :datetime
		add_column :interviews, :ended_at_hour, :integer
		add_column :interviews, :ended_at_minute, :integer
		add_column :interviews, :ended_at_meridiem, :string
	end

	def self.down
		remove_column :interviews, :ended_at_meridiem
		remove_column :interviews, :ended_at_minute
		remove_column :interviews, :ended_at_hour
		remove_column :interviews, :ended_at
		remove_column :interviews, :began_at_meridiem
		remove_column :interviews, :began_at_minute
		remove_column :interviews, :began_at_hour
		remove_column :interviews, :began_at
	end
end
