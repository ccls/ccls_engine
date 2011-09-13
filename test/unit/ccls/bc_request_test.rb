require 'test_helper'

class Ccls::BcRequestTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_belong_to( :study_subject )
	assert_should_protect( :study_subject_id )
	assert_should_not_require(:request_type, :status)
	assert_should_require_attribute_length( :request_type, :status, :maximum => 250 )

	test "statuses should return an array of strings" do
		statuses = BcRequest.statuses
		assert statuses.is_a?(Array)
		assert_equal 4, statuses.length
		statuses.each { |s| assert s.is_a?(String) }
	end

end
