require 'test_helper'

class Ccls::DiagnosisTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes(:position)
	assert_should_require_attribute_length( :description, :in => 3..250 )
	assert_should_act_as_list

	test "should return description as to_s" do
		diagnosis = create_diagnosis
		assert_equal diagnosis.description, "#{diagnosis}"
	end

protected

	def create_diagnosis(options={})
		diagnosis = Factory.build(:diagnosis,options)
		diagnosis.save
		diagnosis
	end

end
