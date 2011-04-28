class AddFieldsToIdentifiers < SharedMigration
	def self.up
		add_column :identifiers, :childidwho, :string, :limit => 10
		add_column :identifiers, :studyid, :string, :limit => 14
		add_column :identifiers, :newid, :string, :limit => 6
		add_column :identifiers, :gbid, :string, :limit => 26
		add_column :identifiers, :lab_no_wiemels, :string, :limit => 25
		add_column :identifiers, :idno_wiemels, :string, :limit => 10
		add_column :identifiers, :accession_no, :string, :limit => 25
		add_column :identifiers, :studyid_nohyphen, :string, :limit => 12
		add_column :identifiers, :studyid_intonly_nohyphen, :string, :limit => 12
		add_column :identifiers, :icf_master_id, :string, :limit => 9
	end

	def self.down
		remove_column :identifiers, :childidwho
		remove_column :identifiers, :studyid
		remove_column :identifiers, :newid
		remove_column :identifiers, :gbid
		remove_column :identifiers, :lab_no_wiemels
		remove_column :identifiers, :idno_wiemels
		remove_column :identifiers, :accession_no
		remove_column :identifiers, :studyid_nohyphen
		remove_column :identifiers, :studyid_intonly_nohyphen
		remove_column :identifiers, :icf_master_id
	end
end
