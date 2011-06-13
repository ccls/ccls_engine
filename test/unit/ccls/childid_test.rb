require 'test_helper'

class Ccls::ChildidTest < ActiveSupport::TestCase

	test "should create and destroy" do
		assert_difference("#{model_name}.next_id",1) {
		assert_difference("#{model_name}.count",0) {
			Childid.create!.destroy
		} }
	end

	test "should be able to stub id" do
		Childid.any_instance.stubs(:id).returns(123)
		c = Childid.create
		assert_equal 123, c.id
	end

end
