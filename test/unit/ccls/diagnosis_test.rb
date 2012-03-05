require 'test_helper'

class Ccls::DiagnosisTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_require_attributes( :code )
	assert_should_require_unique_attributes( :code )
	assert_should_not_require_attributes(:position)
	assert_should_act_as_list
	#	NOTE	code is an integer for diagnosis (so key is used)

	test "explicit Factory diagnosis test" do
		assert_difference('Diagnosis.count',1) {
			diagnosis = Factory(:diagnosis)
			assert_match /key\d*/,  diagnosis.key
			assert_match /\d*/,     diagnosis.code.to_s
			assert_match /Desc\d*/, diagnosis.description
		}
	end

	test "should return description as to_s" do
		diagnosis = create_diagnosis
		assert_equal diagnosis.description, "#{diagnosis}"
	end

	test "Diagnosis['other'] should return true for is_other?" do
		diagnosis = Diagnosis['other']
		assert diagnosis.is_other?
	end

	test "Diagnosis['ALL'] should return false for is_other?" do
		diagnosis = Diagnosis['ALL']
		assert !diagnosis.is_other?
	end

	test "Diagnosis['AML'] should return false for is_other?" do
		diagnosis = Diagnosis['AML']
		assert !diagnosis.is_other?
	end

#protected
#
#	def create_diagnosis(options={})
#		diagnosis = Factory.build(:diagnosis,options)
#		diagnosis.save
#		diagnosis
#	end

end
