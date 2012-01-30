module Ccls::IcfMasterTrackerTestHelper

	def create_test_file_and_icf_master_tracker
		create_icf_master_tracker_test_file
		icf_master_tracker = create_icf_master_tracker_with_file
	end

	def create_icf_master_tracker_with_file
		icf_master_tracker = Factory(:icf_master_tracker,
			:csv_file => File.open(test_file_name) )
		assert_not_nil icf_master_tracker.csv_file_file_name
		icf_master_tracker
	end

	def cleanup_icf_master_tracker_and_test_file(icf_master_tracker=nil)
		if icf_master_tracker
			icf_master_tracker_file = icf_master_tracker.csv_file.path
			#	explicit destroy to remove attachment
			icf_master_tracker.destroy	
			unless icf_master_tracker_file.blank?
				assert !File.exists?(icf_master_tracker_file)
			end
		end
		if File.exists?(test_file_name)
			#	explicit delete to remove test file
			File.delete(test_file_name)	
		end
		assert !File.exists?(test_file_name)
	end

	def create_case_for_icf_master_tracker
		icf_master_id = Factory(:icf_master_id,:icf_master_id => '1234FAKE')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		assert_equal '1234FAKE', study_subject.icf_master_id
		study_subject
	end

	def csv_file_header
		%{"Masterid","Motherid","Record_Owner","Datereceived","Lastatt","Lastdisp","Currphone","Vacauthrecd","Recollect","Needpreincentive","Active_Phone","Recordsentformatching","Recordreceivedfrommatching","Sentpreincentive","Releasedtocati","Confirmedcaticontact","Refused","Deceasednotification","Eligible","Confirmationpacketsent","Catiprotocolexhausted","Newphonenumreleasedtocati","Pleanotificationsent","Casereturnedtoberkeleyfornewinf","Casereturnedfromberkeley","Caticomplete","Kitmothersent","Kitinfantsent","Kitchildsent","Kitadolescentsent","Kitmotherrefusedcode","Kitchildrefusedcode","Noresponsetoplea","Responsereceivedfromplea","Senttoinpersonfollowup","Kitmotherrecd","Kitchildrecvd","Thankyousent","Physrequestsent","Physresponsereceived"}
	end

#	def csv_file_unknown
#		"1234FAKE,unknown,1,,1/18/2012,Jane Smith,Jones,John Smith,Jimmy Smith,1,6,2009,M,United States,CA,Bakersfield,2,2,1,,2,2,1,"
#	end

	def csv_file_study_subject
#		"1234FAKE,case,1,,1/18/2012,Jane Smith,Jones,John Smith,Jimmy Smith,1,6,2009,M,United States,CA,Bakersfield,2,2,1,,2,2,1,"
		%{"1234FAKE","4567FAKE","ICF",9/9/2011,12/17/2011,113,"2 of 2",,,9/17/11 9:29 AM,,9/16/2011,9/16/2011,9/17/2011,9/17/2011,9/28/2011,12/15/2011,,,,12/17/2011,11/14/2011,11/14/2011,12/19/2011,12/22/2011,,,,,,,,,,,,,,,}
	end

#	def csv_file_control
#		"#{control[:masterid]},#{control[:ca_co_status]},#{control[:biomom]},#{control[:biodad]},#{control[:date]},#{control[:mother_full_name]},#{control[:mother_maiden_name]},#{control[:father_full_name]},#{control[:child_full_name]},#{control[:child_dobm]},#{control[:child_dobd]},#{control[:child_doby]},#{control[:child_gender]},#{control[:birthplace_country]},#{control[:birthplace_state]},#{control[:birthplace_city]},#{control[:mother_hispanicity]},#{control[:mother_hispanicity_mex]},#{control[:mother_race]},#{control[:mother_race_other]},#{control[:father_hispanicity]},#{control[:father_hispanicity_mex]},#{control[:father_race]},#{control[:father_race_other]}"
#	end

	def create_icf_master_tracker_test_file
		File.open(test_file_name,'w'){|f|
			f.puts csv_file_header
			f.puts csv_file_study_subject
#			f.puts csv_file_control 
		}
	end

#	#	broke it down like this so that can access and compare the attributes
#	def control
#		{	:masterid => '1234FAKE',
#			:ca_co_status => 'control',
#			:biomom => 1,
#			:biodad => nil,
#			:date => nil,
#			:mother_full_name => 'Jill Johnson',
#			:mother_maiden_name => 'Jackson',
#			:father_full_name => 'Jack Johnson',
#			:child_full_name => 'Michael Johnson',
#			:child_dobm => 1,
#			:child_dobd => 6,
#			:child_doby => 2009,
#			:child_gender => 'M',
#			:birthplace_country => 'United States',
#			:birthplace_state => 'CA',
#			:birthplace_city => 'Oakland',
#			:mother_hispanicity => 2,
#			:mother_hispanicity_mex => 2,
#			:mother_race => 1,
#			:mother_race_other => nil,
#			:father_hispanicity => 2,
#			:father_hispanicity_mex => 2,
#			:father_race => 1,
#			:father_race_other => nil }
#	end

	def turn_off_paperclip_logging
		#	Is there I way to silence the paperclip output?  Yes...
		Paperclip.options[:log] = false
		#	Is there I way to capture the paperclip output for comparison?  Don't know.
	end

	def test_file_name
		"icf_master_tracker_test_file.csv"
	end

end
