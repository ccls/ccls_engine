require File.dirname(__FILE__) + '/../test_helper'

class EnginePagesControllerTest < ActionController::TestCase

	tests PagesController

	test "ENGINE layout should include aws image" do
		page = Factory(:page)
		get :show, :id => page.id
		assert_select 'img'	#	can't get more specific with assert_select
#<img alt=\"three_bears.jpg\" src=\"https://s3.amazonaws.com/ccls/images/three_bears.jpg\" />
		assert_not_nil @response.body.match(/alt="three_bears.jpg/)
		assert_not_nil @response.body.match(
			/src="https?:\/\/s3.amazonaws.com\/ccls\/images\/three_bears.jpg/)
	end

end
