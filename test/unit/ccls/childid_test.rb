require 'test_helper'

class Ccls::ChildidTest < ActiveSupport::TestCase

	test "should create and destroy" do
		assert_difference("#{model_name}.next_id",1) {
		assert_difference("#{model_name}.count",0) {
			Childid.create!.destroy
		} }
	end

end
