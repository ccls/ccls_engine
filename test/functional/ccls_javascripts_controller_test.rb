require File.dirname(__FILE__) + '/../test_helper'

module Ccls
class JavascriptsControllerTest < ActionController::TestCase
	tests JavascriptsController

	test "should get cache_helper" do
		get 'cache_helper', :format => 'js'
		assert_response :success
		assert_not_nil @response.body.match(/jQuery/)
	end

end
end
