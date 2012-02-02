module Ccls::IcfMasterTrackerUpdateTestHelper

	def create_test_file_and_icf_master_tracker_update(options={})
		create_icf_master_tracker_update_test_file(options)
		icf_master_tracker_update = create_icf_master_tracker_update_with_file
	end

	def create_icf_master_tracker_update_with_file
		icf_master_tracker_update = Factory(:icf_master_tracker_update,
			:csv_file => File.open(csv_test_file_name) )
		assert_not_nil icf_master_tracker_update.csv_file_file_name
		icf_master_tracker_update
	end

	def cleanup_icf_master_tracker_update_and_test_file(icf_master_tracker_update=nil)
		if icf_master_tracker_update
			icf_master_tracker_update_file = icf_master_tracker_update.csv_file.path
			#	explicit destroy to remove attachment
			icf_master_tracker_update.destroy	
			unless icf_master_tracker_update_file.blank?
				assert !File.exists?(icf_master_tracker_update_file)
			end
			if File.exists?("test/icf_master_tracker_update/#{icf_master_tracker_update.id}") &&
				File.directory?("test/icf_master_tracker_update/#{icf_master_tracker_update.id}")
				Dir.delete("test/icf_master_tracker_update/#{icf_master_tracker_update.id}")
			end
		end
		if File.exists?(csv_test_file_name)
			#	explicit delete to remove test file
			File.delete(csv_test_file_name)	
		end
		assert !File.exists?(csv_test_file_name)
	end

	def create_case_for_icf_master_tracker_update
		icf_master_id = Factory(:icf_master_id,:icf_master_id => '1234FAKE')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		assert_equal '1234FAKE', study_subject.icf_master_id
		study_subject
	end

	def csv_file_header_array
#		["Masterid","Motherid","Record_Owner","Datereceived","Lastatt","Lastdisp","Currphone","Vacauthrecd","Recollect","Needpreincentive","Active_Phone","Recordsentformatching","Recordreceivedfrommatching","Sentpreincentive","Releasedtocati","Confirmedcaticontact","Refused","Deceasednotification","Eligible","Confirmationpacketsent","Catiprotocolexhausted","Newphonenumreleasedtocati","Pleanotificationsent","Casereturnedtoberkeleyfornewinf","Casereturnedfromberkeley","Caticomplete","Kitmothersent","Kitinfantsent","Kitchildsent","Kitadolescentsent","Kitmotherrefusedcode","Kitchildrefusedcode","Noresponsetoplea","Responsereceivedfromplea","Senttoinpersonfollowup","Kitmotherrecd","Kitchildrecvd","Thankyousent","Physrequestsent","Physresponsereceived"]
		%w{Masterid Motherid Record_Owner Datereceived Lastatt Lastdisp Currphone Vacauthrecd Recollect Needpreincentive Active_Phone Recordsentformatching Recordreceivedfrommatching Sentpreincentive Releasedtocati Confirmedcaticontact Refused Deceasednotification Eligible Confirmationpacketsent Catiprotocolexhausted Newphonenumreleasedtocati Pleanotificationsent Casereturnedtoberkeleyfornewinf Casereturnedfromberkeley Caticomplete Kitmothersent Kitinfantsent Kitchildsent Kitadolescentsent Kitmotherrefusedcode Kitchildrefusedcode Noresponsetoplea Responsereceivedfromplea Senttoinpersonfollowup Kitmotherrecd Kitchildrecvd Thankyousent Physrequestsent Physresponsereceived}
	end

	def csv_file_header
		csv_file_header_array.collect{|s|"\"#{s}\""}.join(',')
	end

	def csv_file_study_subject(options={})
		subject = study_subject_hash.merge(options)
		csv_file_header_array.collect{|s|"\"#{subject[s]}\""}.join(',')
	end

	def study_subject_hash
		{
			"Masterid" => "1234FAKE",
			"Motherid" => "4567FAKE"

#			"Record_Owner" => "ICF",
#			"Datereceived" => "9/9/2011",
#			"Lastatt" => "12/17/2011",
#			"Lastdisp" => "113",
#			"Currphone" => "2 of 2",
#			"Vacauthrecd" => nil,
#			"Recollect" => nil,
#			"Needpreincentive" => "9/17/11 9:29 AM",
#			"Active_Phone" => nil,
#			"Recordsentformatching" => "9/16/2011",
#			"Recordreceivedfrommatching" => "9/16/2011",
#			"Sentpreincentive" => "9/17/2011",
#			"Releasedtocati" => "9/17/2011",
#			"Confirmedcaticontact" => "9/28/2011",
#			"Refused" => "12/15/2011",
#			"Deceasednotification" => nil,
#			"Eligible" => nil,
#			"Confirmationpacketsent" => nil,
#			"Catiprotocolexhausted" => "12/17/2011",
#			"Newphonenumreleasedtocati" => "11/14/2011",
#			"Pleanotificationsent" => "11/14/2011",
#			"Casereturnedtoberkeleyfornewinf" => "12/19/2011",
#			"Casereturnedfromberkeley" => "12/22/2011",
#			"Caticomplete" => nil,
#			"Kitmothersent" => nil,
#			"Kitinfantsent" => nil,
#			"Kitchildsent" => nil,
#			"Kitadolescentsent" => nil,
#			"Kitmotherrefusedcode" => nil,
#			"Kitchildrefusedcode" => nil,
#			"Noresponsetoplea" => nil,
#			"Responsereceivedfromplea" => nil,
#			"Senttoinpersonfollowup" => nil,
#			"Kitmotherrecd" => nil,
#			"Kitchildrecvd" => nil,
#			"Thankyousent" => nil,
#			"Physrequestsent" => nil,
#			"Physresponsereceived" => nil
		}
	end

	def create_icf_master_tracker_update_test_file(options={})
		File.open(csv_test_file_name,'w'){|f|
			f.puts csv_file_header
			f.puts csv_file_study_subject(options)
		}
	end

	def turn_off_paperclip_logging
		#	Is there I way to silence the paperclip output?  Yes...
		Paperclip.options[:log] = false
		#	Is there I way to capture the paperclip output for comparison?  Don't know.
	end

#	shouldn't be called test_... as makes it a test method!
	def csv_test_file_name
		"icf_master_tracker_update_test_file.csv"
	end

end
