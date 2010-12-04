class AddEventCategoryToOperationalEventTypes < SharedMigration
	def self.up
		add_column :operational_event_types, :event_category, :string
	end

	def self.down
		remove_column :operational_event_types, :event_category
	end
end
