require 'test_helper'

class Ccls::IcfMasterIdTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:study_subject)

	test "should return icf_master_id as to_s" do
		icf_master_id = create_icf_master_id(:icf_master_id => '123456789')
		assert_equal "#{icf_master_id.icf_master_id}", "#{icf_master_id}"
		assert_equal "123456789", "#{icf_master_id}"
	end

protected

	def create_icf_master_id(options={})
		icf_master_id = Factory.build(:icf_master_id,options)
		icf_master_id.save
		icf_master_id
	end

end
