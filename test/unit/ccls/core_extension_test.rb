require File.dirname(__FILE__) + '/../../test_helper'

class Ccls::CoreExtensionTest < ActiveSupport::TestCase

	test "this class exists" do
		assert class_exists?('Ccls::CoreExtensionTest')
	end

	test "non class exists but is not a class" do
		assert !class_exists?('Ccls::UcbCclsEngineHelper')
	end

	test "bogus class does not exist" do
		assert !class_exists?('SomeBogusClass')
	end

end
