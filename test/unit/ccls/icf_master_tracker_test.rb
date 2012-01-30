require 'test_helper'

class Ccls::IcfMasterTrackerTest < ActiveSupport::TestCase
	include Ccls::IcfMasterTrackerTestHelper

	setup :turn_off_paperclip_logging

	assert_should_create_default_object

	test "should create without attached csv_file" do
		assert_difference('IcfMasterTracker.count',1) {
			@object = Factory(:icf_master_tracker)
		}
		assert_nil @object.csv_file_file_name
		assert_nil @object.csv_file_content_type
		assert_nil @object.csv_file_file_size
		assert_nil @object.csv_file_updated_at
	end

	test "should create with attached csv_file" do
		assert_difference('IcfMasterTracker.count',1) {
			@object = create_test_file_and_icf_master_tracker
		}
		assert_not_nil @object.csv_file_file_name
		assert_equal   @object.csv_file_file_name, test_file_name
		assert_not_nil @object.csv_file_content_type
		assert_not_nil @object.csv_file_file_size
		assert_not_nil @object.csv_file_updated_at
		cleanup_icf_master_tracker_and_test_file(@object)
	end

	test "should parse nil attached csv_file" do
		icf_master_tracker = Factory(:icf_master_tracker)
		assert_nil icf_master_tracker.csv_file_file_name
#		assert_difference('CandidateControl.count',0) {
			results = icf_master_tracker.parse
			assert_equal [], results
#		}
	end

	test "should parse non-existant attached csv_file" do
		icf_master_tracker = create_test_file_and_icf_master_tracker
		assert  File.exists?(icf_master_tracker.csv_file.path)
		File.delete(icf_master_tracker.csv_file.path)					#	TODO will leave directories
		assert !File.exists?(icf_master_tracker.csv_file.path)
#		assert_difference('CandidateControl.count',0) {
			results = icf_master_tracker.parse
			assert_equal [], results
#		}
		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
	end

	test "should parse attached csv_file with matching case" do
		study_subject = create_case_for_icf_master_tracker
		icf_master_tracker = create_test_file_and_icf_master_tracker
#		assert_difference('CandidateControl.count',1) {
			results = icf_master_tracker.parse
#			assert_equal 2,  results.length
			assert_equal 1,  results.length
			assert       results[0].is_a?(StudySubject)
			assert       results[0].is_case?
			assert_equal results[0], study_subject
#			assert results[1].is_a?(CandidateControl)
#		}
		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
	end

	test "should parse attached csv_file with missing case" do
		icf_master_tracker = create_test_file_and_icf_master_tracker
#		assert_difference('CandidateControl.count',0) {
			results = icf_master_tracker.parse
			assert_equal results,
				["Could not find identifier with masterid 1234FAKE"]
#			assert_equal results,
#				["Could not find identifier with masterid 1234FAKE",
#				"Could not find identifier with masterid 1234FAKE"]
#		}
		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
	end

	test "should parse attached csv_file with existing candidate control" do
		study_subject = create_case_for_icf_master_tracker
		icf_master_tracker = create_test_file_and_icf_master_tracker
		results = nil
#		assert_difference('CandidateControl.count',1) {
			results = icf_master_tracker.parse
#			assert_equal 2,  results.length
			assert_equal 1,  results.length
			assert       results[0].is_a?(StudySubject)
			assert       results[0].is_case?
			assert_equal results[0], study_subject
#			assert results[1].is_a?(CandidateControl)
#		}
#		assert_difference('CandidateControl.count',0) {
			new_results = icf_master_tracker.parse
#			assert_equal 2,  new_results.length
			assert_equal 1,  new_results.length
			assert       new_results[0].is_a?(StudySubject)
			assert       new_results[0].is_case?
			assert_equal new_results[0], study_subject
#			assert new_results[1].is_a?(CandidateControl)
			assert_equal results, new_results
#		}
		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
	end

#	test "should copy attributes when csv_file converted to candidate control" do
#		study_subject = create_case_for_icf_master_tracker
#		icf_master_tracker = create_test_file_and_icf_master_tracker
#		assert_difference('CandidateControl.count',1) {
#			results = icf_master_tracker.to_candidate_controls
#			assert_equal 2,  results.length
#			candidate_control = results.last
#			assert_equal candidate_control.related_patid, study_subject.patid
#			assert_equal candidate_control.mom_is_biomom, control[:biomom]
#			assert_equal candidate_control.dad_is_biodad, control[:biodad]
##control[:date]},#{
#			assert_equal candidate_control.mother_full_name, control[:mother_full_name]
#			assert_equal candidate_control.mother_maiden_name, control[:mother_maiden_name]
##control[:father_full_name]},#{
#			assert_equal candidate_control.full_name, control[:child_full_name]
#			assert_equal candidate_control.dob, 
#				Date.new(control[:child_doby].to_i, control[:child_dobm].to_i, control[:child_dobd].to_i)
#			assert_equal candidate_control.sex, control[:child_gender]
##control[:birthplace_country]},#{
##control[:birthplace_state]},#{
##control[:birthplace_city]},#{
#			assert_equal candidate_control.mother_hispanicity_id, control[:mother_hispanicity]
##control[:mother_hispanicity_mex]},#{
#			assert_equal candidate_control.mother_race_id, control[:mother_race]
##control[:mother_race_other]},#{
#			assert_equal candidate_control.father_hispanicity_id, control[:father_hispanicity]
##control[:father_hispanicity_mex]},#{
#			assert_equal candidate_control.father_race_id, control[:father_race]
##control[:father_race_other]}} }
#		}
#		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
#	end

	test "should test with real data file" do
		#	real data and won't be in repository
		unless File.exists?('icf_master_tracker_011712.csv')
			puts
			puts "-- Real data test file does not exist. Skipping."
			return 
		end

		#	minimal semi-real case creation
#		s1 = Factory(:case_study_subject,:sex => 'F')
		s1 = Factory(:study_subject,:sex => 'F')
#		s1.create_identifier(:case_control_type => 'C')
#		s1.create_identifier
		s1.create_pii(:first_name => 'FakeFirst1',:last_name => 'FakeLast1', 
			:dob => Date.parse('10/16/1977'))

#		s2 = Factory(:case_study_subject,:sex => 'F')
		s2 = Factory(:study_subject,:sex => 'F')
#		s2.create_identifier(:case_control_type => 'C')
		s2.create_identifier
		s2.create_pii(:first_name => 'FakeFirst2',:last_name => 'FakeLast2', 
			:dob => Date.parse('9/21/1988'))
		Factory(:icf_master_id,:icf_master_id => '15270110G')
		s2.assign_icf_master_id

#		s3 = Factory(:case_study_subject,:sex => 'M')
		s3 = Factory(:study_subject,:sex => 'M')
#		s3.create_identifier(:case_control_type => 'C')
		s3.create_identifier
		s3.create_pii(:first_name => 'FakeFirst3',:last_name => 'FakeLast3', 
			:dob => Date.parse('6/1/2009'))
		Factory(:icf_master_id,:icf_master_id => '15397125B')
		s3.assign_icf_master_id

		icf_master_tracker = Factory(:icf_master_tracker,
			:csv_file => File.open('icf_master_tracker_011712.csv') )
		assert_not_nil icf_master_tracker.csv_file_file_name

#		#	35 lines - 1 header - 3 cases = 31
#		assert_difference('CandidateControl.count',31){
			results = icf_master_tracker.parse
			assert_equal results.length, 62
			assert results[0].is_a?(String)
			assert_equal results[0],
				"Could not find identifier with masterid 10054956K"
			assert       results[1].is_a?(StudySubject)
			assert_equal results[1], s2
			assert       results[2].is_a?(StudySubject)
			assert_equal results[2], s3
#			results.each { |r|
#				if r.is_a?(CandidateControl) and r.new_record?
#					puts r.inspect
#					puts r.errors.full_messages.to_sentence
#				end
#			}
#		}
		icf_master_tracker.destroy
#		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
	end

	test "should return a StudySubject in results for case" do
		study_subject = create_case_for_icf_master_tracker
		File.open(test_file_name,'w'){|f|
			f.puts csv_file_header
			f.puts csv_file_study_subject }
		icf_master_tracker = create_icf_master_tracker_with_file
#		assert_difference('CandidateControl.count',0){
			results = icf_master_tracker.parse
			assert results[0].is_a?(StudySubject)
			assert_equal results[0], study_subject
#		}
		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
	end

#	test "should return a CandidateControl in results for control" do
#		study_subject = create_case_for_icf_master_tracker
#		File.open(test_file_name,'w'){|f|
#			f.puts csv_file_header
#			f.puts csv_file_control }
#		icf_master_tracker = create_icf_master_tracker_with_file
#		assert_difference('CandidateControl.count',1){
#			results = icf_master_tracker.to_candidate_controls
#			assert results[0].is_a?(CandidateControl)
#		}
#		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
#	end
#
#	test "should return a String in results for unknown ca_co_status" do
#		study_subject = create_case_for_icf_master_tracker
#		File.open(test_file_name,'w'){|f|
#			f.puts csv_file_header
#			f.puts csv_file_unknown }
#		icf_master_tracker = create_icf_master_tracker_with_file
#		assert_difference('CandidateControl.count',0){
#			results = icf_master_tracker.to_candidate_controls
#			assert results[0].is_a?(String)
#			assert_equal results[0], "Unexpected ca_co_status :unknown:"
#		}
#		cleanup_icf_master_tracker_and_test_file(icf_master_tracker)
#	end

end
