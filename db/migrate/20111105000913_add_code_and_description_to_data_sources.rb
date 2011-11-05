class AddCodeAndDescriptionToDataSources < SharedMigration
	def self.up
		add_column :data_sources, :code, :string, :null => false
		add_column :data_sources, :description, :string, :null => false
		add_index  :data_sources, :code, :unique => true
	end

	def self.down
		remove_index  :data_sources, :code
		remove_column :data_sources, :description
		remove_column :data_sources, :code
	end
end
