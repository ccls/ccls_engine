require 'test_helper'

class Ccls::AnalysisTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes( :code, :description )
	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :analyst_id,
		:project_id,
		:analytic_file_creator_id,
		:analytic_file_created_date,
		:analytic_file_last_pulled_date,
		:analytic_file_location,
		:analytic_file_filename )
	assert_should_belong_to( :analytic_file_creator, :analyst,
		:class_name => 'Person' )
	assert_should_belong_to( :project )
	assert_should_habtm( :subjects )

end
