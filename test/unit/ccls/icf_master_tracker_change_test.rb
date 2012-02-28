require 'test_helper'

class Ccls::IcfMasterTrackerChangeTest < ActiveSupport::TestCase
#			t.string :icf_master_id
#			t.date :master_tracker_date
#			t.boolean :new_tracker_record
#			t.string :modified_column
#			t.string :previous_value
#			t.string :new_value

	assert_should_create_default_object
	assert_should_require( :icf_master_id )

end
