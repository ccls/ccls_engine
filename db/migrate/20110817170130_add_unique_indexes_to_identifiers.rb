class AddUniqueIndexesToIdentifiers < SharedMigration
	def self.up
		add_index :identifiers, :childid, :unique => true
		add_index :identifiers, :hospital_no, :unique => true
		add_index :identifiers, :studyid, :unique => true
		add_index :identifiers, :gbid, :unique => true
		add_index :identifiers, :lab_no_wiemels, :unique => true
		add_index :identifiers, :idno_wiemels, :unique => true
		add_index :identifiers, :accession_no, :unique => true
		add_index :identifiers, :studyid_nohyphen, :unique => true
		add_index :identifiers, :studyid_intonly_nohyphen, :unique => true
	end

	def self.down
		remove_index :identifiers, :childid
		remove_index :identifiers, :hospital_no
		remove_index :identifiers, :studyid
		remove_index :identifiers, :gbid
		remove_index :identifiers, :lab_no_wiemels
		remove_index :identifiers, :idno_wiemels
		remove_index :identifiers, :accession_no
		remove_index :identifiers, :studyid_nohyphen
		remove_index :identifiers, :studyid_intonly_nohyphen
	end
end
