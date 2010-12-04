class ChangeDescriptionToNullFalseInVitalStatuses < SharedMigration
	def self.up
		change_column :vital_statuses, :description, :string, :null => false
	end

	def self.down
		change_column :vital_statuses, :description, :string, :null => true
	end
end
