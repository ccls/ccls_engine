class RemoveSentOnFromOperationalEvents < SharedMigration
	def self.up
		remove_column :operational_events, :sent_on
	end

	def self.down
		add_column :operational_events, :sent_on, :date
	end
end
