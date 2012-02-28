class RemoveResearchOriginFromDataSources < SharedMigration
	def self.up
		remove_column :data_sources, :research_origin
	end

	def self.down
		add_column :data_sources, :research_origin, :string
	end
end
