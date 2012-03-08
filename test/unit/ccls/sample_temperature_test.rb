require 'test_helper'

class Ccls::SampleTemperatureTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_not_require_attributes( :position )
	assert_should_have_many(:samples)

	test "explicit Factory sample temperature test" do
		assert_difference('SampleTemperature.count',1) {
			sample_temperature = Factory(:sample_temperature)
			assert_match /Key\d*/,  sample_temperature.key
			assert_match /Desc\d*/, sample_temperature.description
		}
	end

	test "should return description as to_s" do
		sample_temperature = create_sample_temperature
		assert_equal sample_temperature.description, "#{sample_temperature}"
	end

end
