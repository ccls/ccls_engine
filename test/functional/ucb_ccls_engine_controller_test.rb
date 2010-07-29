require File.dirname(__FILE__) + '/../test_helper'

class UcbCclsEngineControllerTest < ActionController::TestCase

	setup :define_controller

	test "this class exists" do
		assert @controller.send(:class_exists?,'UcbCclsEngineControllerTest')
	end

	test "non class exists but is not a class" do
		assert !@controller.send(:class_exists?,'UcbCclsEngineHelper')
	end

	test "bogus class does not exist" do
		assert !@controller.send(:class_exists?,'SomeBogusClass')
	end

protected

	def define_controller
		#	There is no actual controller so  ....
		@controller = ApplicationController.new
	end

end
