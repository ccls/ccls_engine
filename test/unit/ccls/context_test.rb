require 'test_helper'

class Ccls::ContextTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position, :notes )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_should_act_as_list
	assert_should_have_many(:units)

	test "should return description as to_s" do
		context = create_context
		assert_equal context.description,
			"#{context}"
	end

	test "should find by code with ['string']" do
		context = Context['addresses']
		assert context.is_a?(Context)
	end

	test "should find by code with [:symbol]" do
		context = Context[:addresses]
		assert context.is_a?(Context)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(Context::NotFound) {
#			context = Context['idonotexist']
#		}
#	end


end
