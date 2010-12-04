class RemoveBeganOnFromOperationalEvents < SharedMigration
	def self.up
		remove_column :operational_events, :began_on
	end

	def self.down
		add_column :operational_events, :began_on, :date
	end
end
