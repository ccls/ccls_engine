class AddPersonTypeIdToPeople < SharedMigration
	def self.up
		add_column :people, :person_type_id, :integer
	end

	def self.down
		remove_column :people, :person_type_id
	end
end
