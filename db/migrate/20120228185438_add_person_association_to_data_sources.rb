class AddPersonAssociationToDataSources < SharedMigration
	def self.up
		add_column :data_sources, :person_id, :integer
		add_column :data_sources, :other_person, :string
	end

	def self.down
		remove_column :data_sources, :person_id
		remove_column :data_sources, :other_person
	end
end
