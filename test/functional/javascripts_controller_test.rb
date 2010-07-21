require File.dirname(__FILE__) + '/../test_helper'

class JavascriptsControllerTest < ActionController::TestCase

	test "should get cache_helper" do
		get 'cache_helper', :format => 'js'
		assert_response :success
		assert_not_nil @response.body.match(/jQuery/)
	end

end
