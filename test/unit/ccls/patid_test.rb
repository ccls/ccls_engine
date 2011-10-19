require 'test_helper'

class Ccls::PatidTest < ActiveSupport::TestCase

	test "should create and destroy" do
		assert_difference("Patid.next_id",1) {
		assert_difference("Patid.count",0) {
			Patid.create!.destroy
		} }
	end

	test "should be able to stub id" do
		Patid.any_instance.stubs(:id).returns(123)
		p = Patid.create
		assert_equal 123, p.id
	end

end
