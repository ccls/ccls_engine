require File.dirname(__FILE__) + '/../../test_helper'

class SimplyPages::RedClothExtensionTest < ActiveSupport::TestCase

	teardown :destroy_relative_url_root

	test "should NOT add relative url root to link when blank" do
		html = textilize('"Link Text":/link/path')
		#=> "<p><a href=\"/link/path\">Link Text</a></p>"
		assert_match(/a href="\/link\/path"/,html)
	end

	test "should add relative url root to link when not blank" do
		ActionController::Base.relative_url_root = "/prefix"
		html = textilize('"Link Text":/link/path')
		#=> "<p><a href=\"/prefix/link/path\">Link Text</a></p>"
		assert_match(/a href="\/prefix\/link\/path"/,html)
	end

	test "should NOT add relative url root to image href when blank" do
		html = textilize('!/path/to/image.jpg!:/link/path')
		#=> "<p><a href=\"/link/path\">
		#	<img src=\"/path/to/image.jpg\" alt=\"\" /></a></p>"
		assert_match(/a href="\/link\/path"/,html)
	end

	test "should add relative url root to image href when not blank" do
		ActionController::Base.relative_url_root = "/prefix"
		html = textilize('!/path/to/image.jpg!:/link/path')
		#=> "<p><a href=\"/link/path\">
		#	<img src=\"/path/to/image.jpg\" alt=\"\" /></a></p>"
		assert_match(/a href="\/prefix\/link\/path"/,html)
	end

	test "should NOT add relative url root to image src when blank" do
		html = textilize('!/path/to/image.jpg!:/link/path')
		#=> "<p><a href=\"/link/path\">
		#	<img src=\"/path/to/image.jpg\" alt=\"\" /></a></p>"
		assert_match(/img src="\/path\/to\/image\.jpg"/,html)
	end

	test "should add relative url root to image src when not blank" do
		ActionController::Base.relative_url_root = "/prefix"
		html = textilize('!/path/to/image.jpg!:/link/path')
		#=> "<p><a href=\"/link/path\">
		#	<img src=\"/path/to/image.jpg\" alt=\"\" /></a></p>"
		assert_match(/img src="\/prefix\/path\/to\/image\.jpg"/,html)
	end


#	Add tests for when 
#		relative_url_root is nil
#		paths are absolute
#		paths are relative to current location ('../......')
#		there is no path, just the file


protected

	def destroy_relative_url_root
		ActionController::Base.relative_url_root = nil	#''
	end

end
