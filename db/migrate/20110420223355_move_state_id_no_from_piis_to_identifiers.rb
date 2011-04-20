class MoveStateIdNoFromPiisToIdentifiers < SharedMigration
	def self.up
		remove_index  :piis, :state_id_no
		remove_column :piis, :state_id_no
		add_column :identifiers, :state_id_no, :string
		add_index  :identifiers, :state_id_no, :unique => true
	end

	def self.down
		remove_index  :identifiers, :state_id_no
		remove_column :identifiers, :state_id_no
		add_column :piis, :state_id_no, :string
		add_index  :piis, :state_id_no, :unique => true
	end
end
