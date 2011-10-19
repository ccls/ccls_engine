require 'test_helper'

class Ccls::SectionTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:follow_ups)
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_attribute_length( :description,    :in => 4..250 )
#	assert_should_require_attribute_length( :event_category, :in => 4..250 )

	test "should return description as to_s" do
		section = create_section
		assert_equal section.description, "#{section}"
	end

	test "should find by code with ['string']" do
		create_section(:code => 'justatest')
		section = Section['justatest']
		assert section.is_a?(Section)
	end

	test "should find by code with [:symbol]" do
		create_section(:code => 'justatest')
		section = Section[:justatest]
		assert section.is_a?(Section)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(OperationalEventType::NotFound) {
#			section = OperationalEventType['idonotexist']
#		}
#	end

protected

	def create_section(options={})
		section = Factory.build(:section,options)
		section.save
		section
	end

end
