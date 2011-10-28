class MoveHospitalNoFromIdentifiersToPatients < SharedMigration
#
#	I had considered copying the hospital_no, but since this is all
#	dummy data right now, and there doesn't seem to be any hospital_no,
#	I'm not.  However, if it is required, I'm gonna have to put
#	something in there, unless I allow NULL and leave it NULL.
#
	def self.up
		add_column :patients, :hospital_no, :string, :limit => 25
		add_index :patients, [:hospital_no,:organization_id],
			:unique => true, :name => 'hosp_org'
		remove_column :identifiers, :hospital_no
	end

	def self.down
		add_column :identifiers, :hospital_no, :string, :limit => 25
		remove_index  :patients, :name => 'hosp_org'
		remove_column :patients, :hospital_no
	end
end
