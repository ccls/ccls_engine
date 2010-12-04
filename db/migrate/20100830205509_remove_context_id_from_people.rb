class RemoveContextIdFromPeople < SharedMigration
	def self.up
		remove_column :people, :context_id
	end

	def self.down
		add_column :people, :context_id, :integer
	end
end
