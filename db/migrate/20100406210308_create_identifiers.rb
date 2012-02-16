class CreateIdentifiers < SharedMigration
	def self.up
#		create_table :identifiers do |t|
#			t.references :study_subject
#			t.integer :childid
#			t.string  :patid, :limit => 4
#			t.string  :case_control_type, :limit => 1
#			t.integer :orderno
#			t.string :lab_no
#			t.string :related_childid
#			t.string :related_case_childid
#			t.string :ssn
#			t.string :subjectid, :limit => 6
#			t.string :matchingid, :limit => 6
#			t.string :familyid, :limit => 6
#			t.string :state_id_no
#			t.string :childidwho, :limit => 10
#			t.string :studyid, :limit => 14
#			t.string :newid, :limit => 6
#			t.string :gbid, :limit => 26
#			t.string :lab_no_wiemels, :limit => 25
#			t.string :idno_wiemels, :limit => 10
#			t.string :accession_no, :limit => 25
#			t.string :studyid_nohyphen, :limit => 12
#			t.string :studyid_intonly_nohyphen, :limit => 12
#			t.string :icf_master_id, :limit => 9
#			t.string :state_registrar_no
#			t.string :local_registrar_no
#			t.timestamps
#		end
#		add_index :identifiers, :ssn, :unique => true
#		add_index :identifiers, [:patid,:case_control_type,:orderno],
#			:unique => true,:name => 'piccton'
#		add_index :identifiers, :study_subject_id, :unique => true
#		add_index :identifiers, :subjectid, :unique => true
#		add_index :identifiers, :state_id_no, :unique => true
#		add_index :identifiers, :icf_master_id, :unique => true
#		add_index  :identifiers, :state_registrar_no, :unique => true
#		add_index  :identifiers, :local_registrar_no, :unique => true
#		add_index :identifiers, :childid, :unique => true
#		add_index :identifiers, :studyid, :unique => true
#		add_index :identifiers, :gbid, :unique => true
#		add_index :identifiers, :lab_no_wiemels, :unique => true
#		add_index :identifiers, :idno_wiemels, :unique => true
#		add_index :identifiers, :accession_no, :unique => true
#		add_index :identifiers, :studyid_nohyphen, :unique => true
#		add_index :identifiers, :studyid_intonly_nohyphen, :unique => true
	end

	def self.down
#		drop_table :identifiers
	end
end
