require 'test_helper'

class Ccls::MakerTest < ActiveSupport::TestCase

	assert_should_have_many :widgets

	test "should have 2 makers" do
		assert_equal 2, Maker.count
	end

	test "should create maker" do
		assert_difference('Maker.count') {
			assert Maker.create()
		}
	end

end
