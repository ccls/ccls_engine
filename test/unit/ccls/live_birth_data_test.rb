require 'test_helper'

class Ccls::LiveBirthDataTest < ActiveSupport::TestCase

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
		test_file_name = "live_birth_data_test_file"
		File.open(test_file_name,'w'){|f|f.puts 'testing'}
		assert_difference('LiveBirthData.count',1) {
			@object = Factory(:live_birth_data,
				:csv_file => File.open(test_file_name)
			)
		}
		assert_not_nil @object.csv_file_file_name
		assert_equal   @object.csv_file_file_name, test_file_name
		assert_not_nil @object.csv_file_content_type
		assert_not_nil @object.csv_file_file_size
		assert_not_nil @object.csv_file_updated_at
		#	explicit destroy to remove attachment
		@object.destroy	
		#	explicit delete to remove test file
		File.delete(test_file_name)	
	end

	test "should convert nil attached csv_file to candidate controls" do
		live_birth_data = Factory(:live_birth_data)
		assert_nil live_birth_data.csv_file_file_name
		live_birth_data.to_candidate_controls

#	and then???
	end

	test "should convert non-existant attached csv_file to candidate controls" do
		test_file_name = create_test_file
		live_birth_data = Factory(:live_birth_data,
			:csv_file => File.open(test_file_name) )
		assert_not_nil live_birth_data.csv_file_file_name
		assert  File.exists?(live_birth_data.csv_file.path)
		File.delete(live_birth_data.csv_file.path)
		assert !File.exists?(live_birth_data.csv_file.path)

		live_birth_data.to_candidate_controls

#	and then???

		#	explicit destroy to remove attachment
		live_birth_data.destroy	
		#	explicit delete to remove test file
		File.delete(test_file_name)	
	end

	test "should convert attached csv_file to candidate controls" do
		test_file_name = create_test_file
		live_birth_data = Factory(:live_birth_data,
			:csv_file => File.open(test_file_name) )
		assert_not_nil live_birth_data.csv_file_file_name

		live_birth_data.to_candidate_controls

#	and then???

		#	explicit destroy to remove attachment
		live_birth_data.destroy	
		#	explicit delete to remove test file
		File.delete(test_file_name)	
	end

	test "should convert attached csv_file to candidate controls with missing case" do
pending	#	TODO
	end

protected

	def create_test_file
		test_file_name = "live_birth_data_test_file.csv"
		File.open(test_file_name,'w'){|f|f.puts %{masterid,ca_co_status,biomom,biodad,date,mother_full_name,mother_maiden_name,father_full_name,child_full_name,child_dobm,child_dobd,child_doby,child_gender,birthplace_country,birthplace_state,birthplace_city,mother_hispanicity,mother_hispanicity_mex,mother_race,mother_race_other,father_hispanicity,father_hispanicity_mex,father_race,father_race_other
1234FAKE,case,1,,1/18/2012,Jane Smith,Jones,John Smith,Jimmy Smith,1,6,2009,M,United States,CA,Bakersfield,2,2,1,,2,2,1,
1234FAKE,control,1,,,Jill Johnson,Jackson,Jack Johnson,Michael Johnson,1,6,2009,M,United States,CA,Oakland,2,2,1,,2,2,1,} }
		test_file_name
	end

end

__END__

Is there I way to silence the paperclip output?
Is there I way to capture the paperclip output for comparison?


Ccls/Live Birth Data should create default ccls/live_birth_data: [paperclip] Saving attachments.
.
Ccls/Live Birth Data should create with attached csv_file: [paperclip] Saving attachments.
[paperclip] saving /Users/jakewendt/github_repo/ccls/ccls_engine/test/live_birth_data/2/live_birth_data_test_file
[paperclip] Scheduling attachments for deletion.
[paperclip] Deleting attachments.
[paperclip] deleting /Users/jakewendt/github_repo/ccls/ccls_engine/test/live_birth_data/2/live_birth_data_test_file
.
Ccls/Live Birth Data should create without attached csv_file: [paperclip] Saving attachments.
.

