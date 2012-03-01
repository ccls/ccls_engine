require 'test_helper'

class Ccls::TranslationTableTest < ActiveSupport::TestCase

	test "YNDK valid values" do
		assert_equal YNDK.valid_values, [1,2,999]
	end

	test "YNDK selector options" do
		assert_equal YNDK.selector_options, [['Yes',1],['No',2],["Don't Know",999]]
	end

	test "YNODK valid values" do
		assert_equal YNODK.valid_values, [1,2,3,999]
	end

	test "YNODK selector options" do
		assert_equal YNODK.selector_options, 
			[['Yes',1],['No',2],['Other',3],["Don't Know",999]]
	end

	test "YNRDK valid values" do
		assert_equal YNRDK.valid_values, [1,2,999,888]
	end

	test "YNRDK selector options" do
		assert_equal YNRDK.selector_options, 
			[['Yes',1],['No',2],["Don't Know",999],['Refused',888]]
	end

	test "ADNA valid values" do
		assert_equal ADNA.valid_values, [1,2,555,999]
	end

	test "ADNA selector options" do
		assert_equal ADNA.selector_options, 
			[['Agree',1],['Do Not Agree',2],['N/A',555],["Don't Know",999]]
	end

end
