module Ccls::LiveBirthDataTestHelper

	def create_test_file_and_live_birth_data(options={})
		create_live_birth_data_test_file(options)
		live_birth_data = create_live_birth_data_with_file
	end

	def create_live_birth_data_with_file
		live_birth_data = Factory(:live_birth_data,
			:csv_file => File.open(test_file_name) )
		assert_not_nil live_birth_data.csv_file_file_name
		live_birth_data
	end

	def cleanup_live_birth_data_and_test_file(live_birth_data=nil)
		if live_birth_data
			live_birth_data_file = live_birth_data.csv_file.path
			#	explicit destroy to remove attachment
			live_birth_data.destroy	
			unless live_birth_data_file.blank?
				assert !File.exists?(live_birth_data_file)
			end
			if File.exists?("test/live_birth_data/#{live_birth_data.id}") &&
				File.directory?("test/live_birth_data/#{live_birth_data.id}")
				Dir.delete("test/live_birth_data/#{live_birth_data.id}")
			end
		end
		if File.exists?(test_file_name)
			#	explicit delete to remove test file
			File.delete(test_file_name)	
		end
		assert !File.exists?(test_file_name)
	end

	def create_case_for_live_birth_data
		icf_master_id = Factory(:icf_master_id,:icf_master_id => '1234FAKE')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		assert_equal '1234FAKE', study_subject.icf_master_id
		study_subject
	end

	def csv_file_header
		"masterid,ca_co_status,biomom,biodad,date,mother_full_name,mother_maiden_name,father_full_name,child_full_name,child_dobm,child_dobd,child_doby,child_gender,birthplace_country,birthplace_state,birthplace_city,mother_hispanicity,mother_hispanicity_mex,mother_race,mother_race_other,father_hispanicity,father_hispanicity_mex,father_race,father_race_other"
	end

	def csv_file_unknown
		"1234FAKE,unknown,1,,1/18/2012,Jane Smith,Jones,John Smith,Jimmy Smith,1,6,2009,M,United States,CA,Bakersfield,2,2,1,,2,2,1,"
	end

	def csv_file_case_study_subject
		"1234FAKE,case,1,,1/18/2012,Jane Smith,Jones,John Smith,Jimmy Smith,1,6,2009,M,United States,CA,Bakersfield,2,2,1,,2,2,1,"
	end

	def csv_file_control(options={})
		c = control.merge(options)
		"#{c[:masterid]},#{c[:ca_co_status]},#{c[:biomom]},#{c[:biodad]},#{c[:date]},#{c[:mother_full_name]},#{c[:mother_maiden_name]},#{c[:father_full_name]},#{c[:child_full_name]},#{c[:child_dobm]},#{c[:child_dobd]},#{c[:child_doby]},#{c[:child_gender]},#{c[:birthplace_country]},#{c[:birthplace_state]},#{c[:birthplace_city]},#{c[:mother_hispanicity]},#{c[:mother_hispanicity_mex]},#{c[:mother_race]},#{c[:mother_race_other]},#{c[:father_hispanicity]},#{c[:father_hispanicity_mex]},#{c[:father_race]},#{c[:father_race_other]}"
	end

	def create_live_birth_data_test_file(options={})
		File.open(test_file_name,'w'){|f|
			f.puts csv_file_header
			f.puts csv_file_case_study_subject
			f.puts csv_file_control(options) }
	end

	#	broke it down like this so that can access and compare the attributes
	def control
		{	:masterid => '1234FAKE',
			:ca_co_status => 'control',
			:biomom => 1,
			:biodad => nil,
			:date => nil,
			:mother_full_name => 'Jill Johnson',
			:mother_maiden_name => 'Jackson',
			:father_full_name => 'Jack Johnson',
			:child_full_name => 'Michael Johnson',
			:child_dobm => 1,
			:child_dobd => 6,
			:child_doby => 2009,
			:child_gender => 'M',
			:birthplace_country => 'United States',
			:birthplace_state => 'CA',
			:birthplace_city => 'Oakland',
			:mother_hispanicity => 2,
			:mother_hispanicity_mex => 2,
			:mother_race => 1,
			:mother_race_other => nil,
			:father_hispanicity => 2,
			:father_hispanicity_mex => 2,
			:father_race => 1,
			:father_race_other => nil }
	end

	def turn_off_paperclip_logging
		#	Is there I way to silence the paperclip output?  Yes...
		Paperclip.options[:log] = false
		#	Is there I way to capture the paperclip output for comparison?  Don't know.
	end

	def test_file_name
		"live_birth_data_test_file.csv"
	end

end
