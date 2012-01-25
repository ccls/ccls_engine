require 'test_helper'

class Ccls::LiveBirthDataTest < ActiveSupport::TestCase

	setup :turn_off_paperclip_logging

	assert_should_create_default_object

#	These are String tests and these tests and this method should 
#	be moved into StringExtension

	test "should split persons name into 3 names without middle name" do
		names = "John Smith".split_name
		assert_equal 3, names.length
		assert_equal ['John','','Smith'], names
	end

	test "should split persons name into 3 names with middle name" do
		names = "John Herbert Smith".split_name
		assert_equal 3, names.length
		assert_equal ['John','Herbert','Smith'], names
	end

	test "should split persons name into 3 names with 2 middle names" do
		names = "John Herbert Walker Smith".split_name
		assert_equal 3, names.length
		assert_equal ['John','Herbert Walker','Smith'], names
	end

	test "should split persons name into 3 names with middle initial" do
		names = "John H. Smith".split_name
		assert_equal 3, names.length
		assert_equal ['John','H.','Smith'], names
	end

	test "should split persons name into 3 names even with \\240 codes" do
		names = "John\240Herbert\240Smith".split_name
		assert_equal 3, names.length
		assert_equal ["John","Herbert","Smith"], names
	end

	test "should split persons name into 3 names even with apostrophe" do
		names = "John Herbert O'Grady".split_name
		assert_equal 3, names.length
		assert_equal ["John","Herbert","O'Grady"], names
	end

#	TODO test for name with period like Mary Elizabeth St. James
#	TODO test for name with 2 last names
#	TODO test for name with 2 first names




	test "should create without attached csv_file" do
		assert_difference('LiveBirthData.count',1) {
			@object = Factory(:live_birth_data)
		}
		assert_nil @object.csv_file_file_name
		assert_nil @object.csv_file_content_type
		assert_nil @object.csv_file_file_size
		assert_nil @object.csv_file_updated_at
	end

	test "should create with attached csv_file" do
		assert_difference('LiveBirthData.count',1) {
			@object = create_test_file_and_live_birth_data
		}
		assert_not_nil @object.csv_file_file_name
		assert_equal   @object.csv_file_file_name, test_file_name
		assert_not_nil @object.csv_file_content_type
		assert_not_nil @object.csv_file_file_size
		assert_not_nil @object.csv_file_updated_at
		cleanup_live_birth_data_and_test_file(@object)
	end

	test "should convert nil attached csv_file to candidate controls" do
		live_birth_data = Factory(:live_birth_data)
		assert_nil live_birth_data.csv_file_file_name
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data.to_candidate_controls
			assert_equal [], results
		}
	end

	test "should convert non-existant attached csv_file to candidate controls" do
		live_birth_data = create_test_file_and_live_birth_data
		assert  File.exists?(live_birth_data.csv_file.path)
		File.delete(live_birth_data.csv_file.path)					#	TODO will leave directories
		assert !File.exists?(live_birth_data.csv_file.path)
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data.to_candidate_controls
			assert_equal [], results
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

	test "should convert attached csv_file to candidate controls with matching case" do
		create_case_for_live_birth_data
		live_birth_data = create_test_file_and_live_birth_data
		assert_difference('CandidateControl.count',1) {
			results = live_birth_data.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
#			assert_equal [], results
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

	test "should convert attached csv_file to candidate controls with missing case" do
		live_birth_data = create_test_file_and_live_birth_data
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data.to_candidate_controls
#			assert_equal [nil,nil], results
			assert_equal results,
				["Could not find identifier with masterid 1234FAKE",
				"Could not find identifier with masterid 1234FAKE"]
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

	test "should convert attached csv_file to candidate controls with existing candidate control" do
		create_case_for_live_birth_data
		live_birth_data = create_test_file_and_live_birth_data
		results = nil
		assert_difference('CandidateControl.count',1) {
			results = live_birth_data.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
#			assert_equal [], results
		}
		assert_difference('CandidateControl.count',0) {
			new_results = live_birth_data.to_candidate_controls
#			assert_equal 1,  new_results.length
			assert_equal 2,  new_results.length
			assert new_results[0].is_a?(StudySubject)
			assert new_results[0].is_case?
			assert new_results[1].is_a?(CandidateControl)
			assert_equal results, new_results
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

#	TODO CandidateControl has the following potential validation failures.  
#	What to do for these?
#	Force them with default values?
#
#	validates_presence_of   :first_name
#	validates_presence_of   :last_name
#	validates_presence_of   :dob
#	validates_length_of     :related_patid, :is => 4, :allow_blank => true
#	validates_inclusion_of  :sex, :in => %w( M F DK )


	test "should copy attributes when csv_file converted to candidate control" do
		study_subject = create_case_for_live_birth_data
		live_birth_data = create_test_file_and_live_birth_data
		assert_difference('CandidateControl.count',1) {
			results = live_birth_data.to_candidate_controls
			assert_equal 2,  results.length
#			candidate_control = CandidateControl.find(results.first)
			candidate_control = results.last
			assert_equal candidate_control.related_patid, study_subject.patid
			assert_equal candidate_control.mom_is_biomom, control[:biomom]
			assert_equal candidate_control.dad_is_biodad, control[:biodad]
#control[:date]},#{
			assert_equal candidate_control.mother_full_name, control[:mother_full_name]
			assert_equal candidate_control.mother_maiden_name, control[:mother_maiden_name]
#control[:father_full_name]},#{
			assert_equal candidate_control.full_name, control[:child_full_name]
			assert_equal candidate_control.dob, 
				Date.new(control[:child_doby].to_i, control[:child_dobm].to_i, control[:child_dobd].to_i)
			assert_equal candidate_control.sex, control[:child_gender]
#control[:birthplace_country]},#{
#control[:birthplace_state]},#{
#control[:birthplace_city]},#{
			assert_equal candidate_control.mother_hispanicity_id, control[:mother_hispanicity]
#control[:mother_hispanicity_mex]},#{
			assert_equal candidate_control.mother_race_id, control[:mother_race]
#control[:mother_race_other]},#{
			assert_equal candidate_control.father_hispanicity_id, control[:father_hispanicity]
#control[:father_hispanicity_mex]},#{
			assert_equal candidate_control.father_race_id, control[:father_race]
#control[:father_race_other]}} }
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end



	test "should test with real data file" do
		#	real data and won't be in repository
		unless File.exists?('test-livebirthdata_011912.csv')
			puts
			puts "-- Real data test file does not exist. Skipping."
			return 
		end

		#	minimal semi-real case creation
		s1 = Factory(:case_study_subject,:sex => 'F')
		s1.create_identifier(:case_control_type => 'C')
		s1.create_pii(:first_name => 'FakeFirst1',:last_name => 'FakeLast1', 
			:dob => Date.parse('10/16/1977'))
		#	s1 has no icf_master_id, so should be ignored

		s2 = Factory(:case_study_subject,:sex => 'F')
		s2.create_identifier(:case_control_type => 'C')
		s2.create_pii(:first_name => 'FakeFirst2',:last_name => 'FakeLast2', 
			:dob => Date.parse('9/21/1988'))
		Factory(:icf_master_id,:icf_master_id => '48882638A')
		s2.assign_icf_master_id

		s3 = Factory(:case_study_subject,:sex => 'M')
		s3.create_identifier(:case_control_type => 'C')
		s3.create_pii(:first_name => 'FakeFirst3',:last_name => 'FakeLast3', 
			:dob => Date.parse('6/1/2009'))
		Factory(:icf_master_id,:icf_master_id => '16655682G')
		s3.assign_icf_master_id

		live_birth_data = Factory(:live_birth_data,
			:csv_file => File.open('test-livebirthdata_011912.csv') )
		assert_not_nil live_birth_data.csv_file_file_name

		#	35 lines - 1 header - 3 cases = 31
		assert_difference('CandidateControl.count',31){
			results = live_birth_data.to_candidate_controls
#			assert results[0].nil?
			assert results[0].is_a?(String)
			assert_equal results[0],
				"Could not find identifier with masterid [no ID assigned]"
			assert results[1].is_a?(StudySubject)
			assert results[2].is_a?(StudySubject)
			results.each { |r|
				if r.is_a?(CandidateControl) and r.new_record?
					puts r.inspect
					puts r.errors.full_messages.to_sentence
				end
			}
		}
	end

#	TODO test unknown ca_co_status

protected

	def create_test_file_and_live_birth_data
		create_test_file
		live_birth_data = Factory(:live_birth_data,
			:csv_file => File.open(test_file_name) )
		assert_not_nil live_birth_data.csv_file_file_name
		live_birth_data
	end

	def cleanup_live_birth_data_and_test_file(live_birth_data)
		#	explicit destroy to remove attachment
		live_birth_data.destroy	
#		assert !File.exists?(live_birth_data.csv_file.path)
		#	explicit delete to remove test file
		File.delete(test_file_name)	
		assert !File.exists?(test_file_name)
	end

	def create_case_for_live_birth_data
		icf_master_id = Factory(:icf_master_id,:icf_master_id => '1234FAKE')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		assert_equal '1234FAKE', study_subject.icf_master_id
		study_subject
	end

	def create_test_file
		File.open(test_file_name,'w'){|f|f.puts %{masterid,ca_co_status,biomom,biodad,date,mother_full_name,mother_maiden_name,father_full_name,child_full_name,child_dobm,child_dobd,child_doby,child_gender,birthplace_country,birthplace_state,birthplace_city,mother_hispanicity,mother_hispanicity_mex,mother_race,mother_race_other,father_hispanicity,father_hispanicity_mex,father_race,father_race_other
1234FAKE,case,1,,1/18/2012,Jane Smith,Jones,John Smith,Jimmy Smith,1,6,2009,M,United States,CA,Bakersfield,2,2,1,,2,2,1,
#{control[:masterid]},#{control[:ca_co_status]},#{control[:biomom]},#{control[:biodad]},#{control[:date]},#{control[:mother_full_name]},#{control[:mother_maiden_name]},#{control[:father_full_name]},#{control[:child_full_name]},#{control[:child_dobm]},#{control[:child_dobd]},#{control[:child_doby]},#{control[:child_gender]},#{control[:birthplace_country]},#{control[:birthplace_state]},#{control[:birthplace_city]},#{control[:mother_hispanicity]},#{control[:mother_hispanicity_mex]},#{control[:mother_race]},#{control[:mother_race_other]},#{control[:father_hispanicity]},#{control[:father_hispanicity_mex]},#{control[:father_race]},#{control[:father_race_other]}} }
#1234FAKE,control,1,,,Jill Johnson,Jackson,Jack Johnson,Michael Johnson,1,6,2009,M,United States,CA,Oakland,2,2,1,,2,2,1,} }
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
