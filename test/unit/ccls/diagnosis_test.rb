require 'test_helper'

class Ccls::DiagnosisTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes( :key, :code, :description )
	assert_should_require_unique_attributes( :key, :code, :description )
	assert_should_not_require_attributes(:position)
	assert_should_require_attribute_length( :description, :in => 3..250 )
	assert_should_require_attribute_length( :key, :maximum => 250 )
	assert_should_act_as_list
	#	NOTE	code is an integer for diagnosis (so key is used)

	test "should return description as to_s" do
		diagnosis = create_diagnosis
		assert_equal diagnosis.description, "#{diagnosis}"
	end

	test "should find by key with ['string']" do
		diagnosis = Diagnosis['ALL']
		assert diagnosis.is_a?(Diagnosis)
	end

	test "should find by key with [:symbol]" do
		diagnosis = Diagnosis[:ALL]
		assert diagnosis.is_a?(Diagnosis)
	end

#	test "should raise error if not found by key with []" do
#		assert_raise(Diagnosis::NotFound) {
#			diagnosis = Diagnosis['idonotexist']
#		}
#	end

protected

	def create_diagnosis(options={})
		diagnosis = Factory.build(:diagnosis,options)
		diagnosis.save
		diagnosis
	end

end
