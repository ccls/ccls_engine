class AddRegistrarNosToIdentifiers < SharedMigration
	def self.up
		add_column :identifiers, :state_registrar_no, :string
		add_column :identifiers, :local_registrar_no, :string
		add_index  :identifiers, :state_registrar_no, :unique => true
		add_index  :identifiers, :local_registrar_no, :unique => true
	end

	def self.down
		remove_index  :identifiers, :local_registrar_no
		remove_index  :identifiers, :state_registrar_no
		remove_column :identifiers, :local_registrar_no
		remove_column :identifiers, :state_registrar_no
	end
end
