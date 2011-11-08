require 'test_helper'

class Ccls::DataSourceTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
#	assert_should_have_many(:addresses)
	assert_should_not_require_attributes( 
		:position, 
		:research_origin, 
		:data_origin )
	assert_should_require_attribute_length( 
		:research_origin, 
		:data_origin, 
			:maximum => 250 )

	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code )
	assert_should_require_attribute_length( :code, :description, :maximum => 250 )

	test "should return description as to_s" do
		data_source = create_data_source
		assert_equal data_source.description,
			"#{data_source}"
	end

	test "should find by code with ['string']" do
		data_source = DataSource['raf']
		assert data_source.is_a?(DataSource)
	end

	test "should find by code with [:symbol]" do
		data_source = DataSource[:raf]
		assert data_source.is_a?(DataSource)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(DataSource::NotFound) {
#			data_source = DataSource['idonotexist']
#		}
#	end

end
