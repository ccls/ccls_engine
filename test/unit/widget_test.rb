require 'test_helper'

class WidgetTest < ActiveSupport::TestCase

	assert_should_belong_to :maker

	test "should have widgets" do
		assert_equal 2, Widget.count
	end

	test "should create" do
		assert_difference('Widget.count') {
			assert Widget.create()
		}
	end

	test "should be in different database" do
		config = Widget.connection.instance_variable_get("@config")
		assert_match /shared.*test/, config[:database]
	end

end
