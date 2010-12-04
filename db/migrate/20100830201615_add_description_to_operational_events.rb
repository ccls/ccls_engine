class AddDescriptionToOperationalEvents < SharedMigration
	def self.up
		add_column :operational_events, :description, :string
	end

	def self.down
		remove_column :operational_events, :description
	end
end
