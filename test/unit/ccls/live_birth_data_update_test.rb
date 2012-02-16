require 'test_helper'

class Ccls::LiveBirthDataUpdateTest < ActiveSupport::TestCase
	include Ccls::LiveBirthDataUpdateTestHelper

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
		assert_difference('LiveBirthDataUpdate.count',1) {
			@object = Factory(:live_birth_data_update)
		}
		assert_nil @object.csv_file_file_name
		assert_nil @object.csv_file_content_type
		assert_nil @object.csv_file_file_size
		assert_nil @object.csv_file_updated_at
	end

	test "should create with attached csv_file" do
		assert_difference('LiveBirthDataUpdate.count',1) {
			@object = create_test_file_and_live_birth_data_update
		}
		assert_not_nil @object.csv_file_file_name
		assert_equal   @object.csv_file_file_name, csv_test_file_name
		assert_not_nil @object.csv_file_content_type
		assert_not_nil @object.csv_file_file_size
		assert_not_nil @object.csv_file_updated_at
		cleanup_live_birth_data_update_and_test_file(@object)
	end

	test "should convert nil attached csv_file to candidate controls" do
		live_birth_data_update = Factory(:live_birth_data_update)
		assert_nil live_birth_data_update.csv_file_file_name
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal [], results
		}
	end

	test "should convert non-existant attached csv_file to candidate controls" do
		live_birth_data_update = create_test_file_and_live_birth_data_update
		assert  File.exists?(live_birth_data_update.csv_file.path)
		File.delete(live_birth_data_update.csv_file.path)
		assert !File.exists?(live_birth_data_update.csv_file.path)
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal [], results
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with matching case" do
		create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update
		assert_difference('CandidateControl.count',1) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with missing case" do
		live_birth_data_update = create_test_file_and_live_birth_data_update
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal results,
				["Could not find study_subject with masterid 1234FAKE",
				"Could not find study_subject with masterid 1234FAKE"]
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with existing candidate control" do
		create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update
		results = nil
		assert_difference('CandidateControl.count',1) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
		}
		assert_difference('CandidateControl.count',0) {
			new_results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  new_results.length
			assert new_results[0].is_a?(StudySubject)
			assert new_results[0].is_case?
			assert new_results[1].is_a?(CandidateControl)
			assert_equal results, new_results
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with blank child_full_name" do
		create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update(:child_full_name => '')
		results = nil
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
			assert results[1].errors.on_attr_and_type?(:first_name, :blank)
			assert results[1].errors.on_attr_and_type?(:last_name,  :blank)
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with blank child_dobm" do
		create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update(:child_dobm => '')
		results = nil
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
			assert results[1].errors.on_attr_and_type?(:dob, :blank)
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with blank child_dobd" do
		create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update(:child_dobd => '')
		results = nil
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
			assert results[1].errors.on_attr_and_type?(:dob, :blank)
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with blank child_doby" do
		create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update(:child_doby => '')
		results = nil
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
			assert results[1].errors.on_attr_and_type?(:dob, :blank)
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should convert attached csv_file to candidate controls with blank child_gender" do
		create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update(:child_gender => '')
		results = nil
		assert_difference('CandidateControl.count',0) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
			assert results[0].is_a?(StudySubject)
			assert results[0].is_case?
			assert results[1].is_a?(CandidateControl)
			assert results[1].errors.on_attr_and_type?(:sex, :inclusion)
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
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
		study_subject = create_case_for_live_birth_data_update
		live_birth_data_update = create_test_file_and_live_birth_data_update
		assert_difference('CandidateControl.count',1) {
			results = live_birth_data_update.to_candidate_controls
			assert_equal 2,  results.length
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
				Date.new(control[:child_doby], control[:child_dobm], control[:child_dobd])
#				Date.new(control[:child_doby].to_i, control[:child_dobm].to_i, control[:child_dobd].to_i)
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
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should test with real data file" do
		#	real data and won't be in repository
		unless File.exists?('test-livebirthdata_011912.csv')
			puts
			puts "-- Real data test file does not exist. Skipping."
			return 
		end

		#	minimal semi-real case creation
		s0 = Factory(:case_study_subject,:sex => 'F',
			:first_name => 'FakeFirst1',:last_name => 'FakeLast1', 
			:dob => Date.parse('10/16/1977'))
		#	s0 has no icf_master_id, so should be ignored

		s1 = Factory(:case_study_subject,:sex => 'F',
			:first_name => 'FakeFirst2',:last_name => 'FakeLast2', 
			:dob => Date.parse('9/21/1988'))
		Factory(:icf_master_id,:icf_master_id => '48882638A')
		s1.assign_icf_master_id

		s2 = Factory(:case_study_subject,:sex => 'M',
			:first_name => 'FakeFirst3',:last_name => 'FakeLast3', 
			:dob => Date.parse('6/1/2009'))
		Factory(:icf_master_id,:icf_master_id => '16655682G')
		s2.assign_icf_master_id

		live_birth_data_update = Factory(:live_birth_data_update,
			:csv_file => File.open('test-livebirthdata_011912.csv') )
		assert_not_nil live_birth_data_update.csv_file_file_name

		#	35 lines - 1 header - 3 cases = 31
		assert_difference('CandidateControl.count',31){
			results = live_birth_data_update.to_candidate_controls
			assert results[0].is_a?(String)
			assert_equal results[0],
				"Could not find study_subject with masterid [no ID assigned]"
			assert results[1].is_a?(StudySubject)
			assert results[2].is_a?(StudySubject)
			assert_equal results[1], s1
			assert_equal results[2], s2
			results.each { |r|
				if r.is_a?(CandidateControl) and r.new_record?
					puts r.inspect
					puts r.errors.full_messages.to_sentence
				end
			}
		}
		live_birth_data_update.destroy
#		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should return a StudySubject in results for case" do
		study_subject = create_case_for_live_birth_data_update
		File.open(csv_test_file_name,'w'){|f|
			f.puts csv_file_header
			f.puts csv_file_case_study_subject }
		live_birth_data_update = create_live_birth_data_update_with_file
		assert_difference('CandidateControl.count',0){
			results = live_birth_data_update.to_candidate_controls
			assert results[0].is_a?(StudySubject)
			assert_equal results[0], study_subject
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should return a CandidateControl in results for control" do
		study_subject = create_case_for_live_birth_data_update
		File.open(csv_test_file_name,'w'){|f|
			f.puts csv_file_header
			f.puts csv_file_control }
		live_birth_data_update = create_live_birth_data_update_with_file
		assert_difference('CandidateControl.count',1){
			results = live_birth_data_update.to_candidate_controls
			assert results[0].is_a?(CandidateControl)
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

	test "should return a String in results for unknown ca_co_status" do
		study_subject = create_case_for_live_birth_data_update
		File.open(csv_test_file_name,'w'){|f|
			f.puts csv_file_header
			f.puts csv_file_unknown }
		live_birth_data_update = create_live_birth_data_update_with_file
		assert_difference('CandidateControl.count',0){
			results = live_birth_data_update.to_candidate_controls
			assert results[0].is_a?(String)
			assert_equal results[0], "Unexpected ca_co_status :unknown:"
		}
		cleanup_live_birth_data_update_and_test_file(live_birth_data_update)
	end

end
