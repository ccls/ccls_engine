require 'test_helper'

class Ccls::PatidTest < ActiveSupport::TestCase

	test "should create and destroy" do
		assert_difference("#{model_name}.next_id",1) {
		assert_difference("#{model_name}.count",0) {
			Patid.create!.destroy
		} }
	end

end
