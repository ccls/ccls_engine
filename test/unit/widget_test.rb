require 'test_helper'

class WidgetTest < ActiveSupport::TestCase

	test "should create" do
		assert_difference('Widget.count') {
			assert Widget.create()
		}
	end

end
