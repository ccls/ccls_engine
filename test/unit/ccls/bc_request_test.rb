require 'test_helper'

class Ccls::BcRequestTest < ActiveSupport::TestCase
	assert_should_create_default_object

	test "statuses should return an array of strings" do
		statuses = BcRequest.statuses
		assert statuses.is_a?(Array)
		assert_equal 4, statuses.length
		statuses.each { |s| assert s.is_a?(String) }
	end

end
