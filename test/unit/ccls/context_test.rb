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

	test "explicit Factory context test" do
		assert_difference('Context.count',1) {
			context = Factory(:context)
			assert_match /Code\d*/, context.code
			assert_match /Desc\d*/, context.description
		}
	end

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

	test "should have many context_data_sources" do
		context = Context[:addresses]
		assert !context.context_data_sources.empty?
		assert_difference('ContextDataSource.count',1) {
			context.data_sources << Factory(:data_source)
		}
	end

	test "should have many data_sources through context_data_sources" do
		context = Context[:addresses]
		assert !context.data_sources.empty?
	end

end
