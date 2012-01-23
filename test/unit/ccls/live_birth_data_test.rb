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

end
