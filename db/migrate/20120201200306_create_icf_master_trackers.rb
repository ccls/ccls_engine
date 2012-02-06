class CreateIcfMasterTrackers < SharedMigration
	def self.up
		create_table :icf_master_trackers do |t|
			t.integer :study_subject_id
			t.boolean :flagged_for_update, :default => false
			t.string :Masterid
			t.string :Motherid
			t.string :Record_Owner
			t.string :Datereceived
			t.string :Lastatt
			t.string :Lastdisp
			t.string :Currphone
			t.string :Vacauthrecd
			t.string :Recollect
			t.string :Needpreincentive
			t.string :Active_Phone
			t.string :Recordsentformatching
			t.string :Recordreceivedfrommatching
			t.string :Sentpreincentive
			t.string :Releasedtocati
			t.string :Confirmedcaticontact
			t.string :Refused
			t.string :Deceasednotification
			t.string :Eligible
			t.string :Confirmationpacketsent
			t.string :Catiprotocolexhausted
			t.string :Newphonenumreleasedtocati
			t.string :Pleanotificationsent
			t.string :Casereturnedtoberkeleyfornewinf
			t.string :Casereturnedfromberkeley
			t.string :Caticomplete
			t.string :Kitmothersent
			t.string :Kitinfantsent
			t.string :Kitchildsent
			t.string :Kitadolescentsent
			t.string :Kitmotherrefusedcode
			t.string :Kitchildrefusedcode
			t.string :Noresponsetoplea
			t.string :Responsereceivedfromplea
			t.string :Senttoinpersonfollowup
			t.string :Kitmotherrecd
			t.string :Kitchildrecvd
			t.string :Thankyousent
			t.string :Physrequestsent
			t.string :Physresponsereceived
			t.timestamps
		end
		add_index :icf_master_trackers, :Masterid, :unique => true
	end

	def self.down
		drop_table :icf_master_trackers
	end
end
