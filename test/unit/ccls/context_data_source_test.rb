require 'test_helper'

class Ccls::ContextDataSourceTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to( :context, :data_source )

protected

	def create_context_data_source(options={})
		context_data_source = Factory.build(:context_data_source,options)
		context_data_source.save
		context_data_source
	end

end
