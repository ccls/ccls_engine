require 'test_helper'

class Ccls::IcfMasterTrackerUpdateTest < ActiveSupport::TestCase
	include Ccls::IcfMasterTrackerUpdateTestHelper

	setup :turn_off_paperclip_logging

	assert_should_create_default_object

	test "should create without attached csv_file" do
		assert_difference('IcfMasterTrackerUpdate.count',1) {
			@object = Factory(:icf_master_tracker_update)
		}
		assert_nil @object.csv_file_file_name
		assert_nil @object.csv_file_content_type
		assert_nil @object.csv_file_file_size
		assert_nil @object.csv_file_updated_at
	end

	test "should create with attached csv_file" do
		assert_difference('IcfMasterTrackerUpdate.count',1) {
			@object = create_test_file_and_icf_master_tracker_update
		}
		assert_not_nil @object.csv_file_file_name
		assert_equal   @object.csv_file_file_name, csv_test_file_name
		assert_not_nil @object.csv_file_content_type
		assert_not_nil @object.csv_file_file_size
		assert_not_nil @object.csv_file_updated_at
		cleanup_icf_master_tracker_update_and_test_file(@object)
	end

	test "should parse nil attached csv_file" do
		icf_master_tracker_update = Factory(:icf_master_tracker_update)
		assert_nil icf_master_tracker_update.csv_file_file_name
		assert_difference('IcfMasterTracker.count',0) {
			results = icf_master_tracker_update.parse
			assert_equal [], results
		}
	end

	test "should parse non-existant attached csv_file" do
		icf_master_tracker_update = create_test_file_and_icf_master_tracker_update
		assert  File.exists?(icf_master_tracker_update.csv_file.path)
		File.delete(icf_master_tracker_update.csv_file.path)
		assert !File.exists?(icf_master_tracker_update.csv_file.path)
		assert_difference('IcfMasterTracker.count',0) {
			results = icf_master_tracker_update.parse
			assert_equal [], results
		}
		cleanup_icf_master_tracker_update_and_test_file(icf_master_tracker_update)
	end

	test "should parse attached csv_file" do
		icf_master_tracker_update = create_test_file_and_icf_master_tracker_update
		assert_difference('IcfMasterTracker.count',1) {
			results = icf_master_tracker_update.parse
			assert_equal results.length, 1
			assert       results[0].is_a?(IcfMasterTracker)
			assert       results[0].flagged_for_update
		}
		cleanup_icf_master_tracker_update_and_test_file(icf_master_tracker_update)
	end

	test "should parse attached csv_file with existing icf_master_tracker" do
		icf_master_tracker_update = create_test_file_and_icf_master_tracker_update
		results = nil
		assert_difference('IcfMasterTracker.count',1) {
			results = icf_master_tracker_update.parse
			assert_equal results.length, 1
			assert       results[0].is_a?(IcfMasterTracker)
			assert       results[0].flagged_for_update
		}
		assert_difference('IcfMasterTracker.count',0) {
			new_results = icf_master_tracker_update.parse
			assert_equal new_results.length, 1
			assert       new_results[0].is_a?(IcfMasterTracker)
			assert_equal results, new_results
		}
		cleanup_icf_master_tracker_update_and_test_file(icf_master_tracker_update)
	end

	test "should copy attributes when csv_file converted to icf_master_tracker" do
		icf_master_tracker_update = create_test_file_and_icf_master_tracker_update
		assert_difference('IcfMasterTracker.count',1) {
			results = icf_master_tracker_update.parse
			assert_equal 1,  results.length
			assert       results[0].flagged_for_update
			icf_master_tracker = results.last
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
		}
		cleanup_icf_master_tracker_update_and_test_file(icf_master_tracker_update)
	end

	test "should parse attached csv_file and attach tracker to subject" do
		study_subject = create_case_for_icf_master_tracker_update
		icf_master_tracker_update = create_test_file_and_icf_master_tracker_update
		assert_difference('IcfMasterTracker.count',1) {
			results = icf_master_tracker_update.parse
			assert_equal results.length, 1
			assert       results[0].flagged_for_update
			assert       results[0].is_a?(IcfMasterTracker)
			assert_equal results[0].study_subject, study_subject
		}
		cleanup_icf_master_tracker_update_and_test_file(icf_master_tracker_update)
	end

	test "should test with real data file" do
		#	real data and won't be in repository
		real_data_file = 'icf_master_tracker_011712.csv'
		unless File.exists?(real_data_file)
			puts
			puts "-- Real data test file does not exist. Skipping."
			return 
		end

		#	minimal semi-real case creation
		s0 = Factory(:study_subject,:sex => 'F',
			:first_name => 'FakeFirst1',:last_name => 'FakeLast1', 
			:dob => Date.parse('10/16/1977'))

		s1 = Factory(:study_subject,:sex => 'F',
			:first_name => 'FakeFirst2',:last_name => 'FakeLast2', 
			:dob => Date.parse('9/21/1988'))
		Factory(:icf_master_id,:icf_master_id => '15270110G')
		s1.assign_icf_master_id

		s2 = Factory(:study_subject,:sex => 'M',
			:first_name => 'FakeFirst3',:last_name => 'FakeLast3', 
			:dob => Date.parse('6/1/2009'))
		Factory(:icf_master_id,:icf_master_id => '15397125B')
		s2.assign_icf_master_id

		icf_master_tracker_update = Factory(:icf_master_tracker_update,
			:csv_file => File.open(real_data_file) )
		assert_not_nil icf_master_tracker_update.csv_file_file_name

		assert_difference('IcfMasterTracker.count',62){
			results = icf_master_tracker_update.parse
			assert_equal results.length, 62
			assert_nil   results[0].study_subject
			assert_equal results[1].study_subject, s1
			assert_equal results[2].study_subject, s2
			results.each { |r|
				assert  r.is_a?(IcfMasterTracker)
				assert !r.new_record?
				assert  r.flagged_for_update
			}
		}
#
#	TODO add some tests to see if anything was updated
#
		icf_master_tracker_update.destroy
	end

end
