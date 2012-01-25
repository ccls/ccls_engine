require 'test_helper'

class Ccls::LiveBirthDataTest < ActiveSupport::TestCase

	setup :turn_off_paperclip_logging

	assert_should_create_default_object

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
			candidate_control_ids = live_birth_data.to_candidate_controls
			assert_equal [], candidate_control_ids
		}
	end

	test "should convert non-existant attached csv_file to candidate controls" do
		live_birth_data = create_test_file_and_live_birth_data
		assert  File.exists?(live_birth_data.csv_file.path)
		File.delete(live_birth_data.csv_file.path)					#	TODO will leave directories
		assert !File.exists?(live_birth_data.csv_file.path)
		assert_difference('CandidateControl.count',0) {
			candidate_control_ids = live_birth_data.to_candidate_controls
			assert_equal [], candidate_control_ids
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

	test "should convert attached csv_file to candidate controls with matching case" do
		create_case_for_live_birth_data
		live_birth_data = create_test_file_and_live_birth_data
		assert_difference('CandidateControl.count',1) {
			candidate_control_ids = live_birth_data.to_candidate_controls
			assert_equal 1,  candidate_control_ids.length
#			assert_equal [], candidate_control_ids
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

	test "should convert attached csv_file to candidate controls with missing case" do
		live_birth_data = create_test_file_and_live_birth_data
		assert_difference('CandidateControl.count',0) {
			candidate_control_ids = live_birth_data.to_candidate_controls
			assert_equal [], candidate_control_ids
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

	test "should convert attached csv_file to candidate controls with existing candidate control" do
		create_case_for_live_birth_data
		live_birth_data = create_test_file_and_live_birth_data
		candidate_control_ids = nil
		assert_difference('CandidateControl.count',1) {
			candidate_control_ids = live_birth_data.to_candidate_controls
			assert_equal 1,  candidate_control_ids.length
#			assert_equal [], candidate_control_ids
		}
		assert_difference('CandidateControl.count',0) {
			new_candidate_control_ids = live_birth_data.to_candidate_controls
			assert_equal 1,  new_candidate_control_ids.length
			assert_equal candidate_control_ids, new_candidate_control_ids
		}
		cleanup_live_birth_data_and_test_file(live_birth_data)
	end

#	TODO CandidateControl has the following potential validation failures.  What to do for these?
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
			candidate_control_ids = live_birth_data.to_candidate_controls
			assert_equal 1,  candidate_control_ids.length
			candidate_control = CandidateControl.find(candidate_control_ids.first)
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
