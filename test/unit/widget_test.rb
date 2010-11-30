require 'test_helper'

class WidgetTest < ActiveSupport::TestCase

	test "should create" do
		assert_difference('Widget.count') {
			assert Widget.create()
		}
	end

	test "should be in different database" do
		config = Widget.connection.instance_variable_get("@config")
		assert_match 'shared_test', config[:database]
	end

end
