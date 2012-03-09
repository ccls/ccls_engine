require 'test_helper'

class Ccls::BcRequestTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to( :study_subject )
	assert_should_protect( :study_subject_id, :study_subject )
	assert_should_not_require(:request_type, :status)
	assert_should_require_attribute_length( :request_type, :status, :maximum => 250 )
	assert_should_require_attribute_length( :notes, :maximum => 65000 )

	test "statuses should return an array of strings" do
		statuses = BcRequest.statuses
		assert statuses.is_a?(Array)
		assert_equal 4, statuses.length
		statuses.each { |s| assert s.is_a?(String) }
	end

	test "explicit Factory bc_request test" do
		assert_difference('BcRequest.count',1) {
			bc_request = Factory(:bc_request)
			assert_match /Notes\d*/, bc_request.notes
		}
	end

	test "should return self for to_s if no study subject" do
		assert_difference('BcRequest.count',1) {
			bc_request = Factory(:bc_request)
			assert_match /^#<BcRequest:0x.+>$/, "#{bc_request}"
		}
	end

	test "should return study subject's studyid for to_s if study subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('BcRequest.count',1) {
			study_subject = Factory(:complete_case_study_subject)
			bc_request = Factory(:bc_request)
			study_subject.bc_requests << bc_request
			assert_equal study_subject.studyid, "#{bc_request}"
		} }
	end

end
