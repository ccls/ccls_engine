require 'test_helper'

class Ccls::RaceTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
#	assert_should_have_many( :study_subjects )
	assert_should_require_attributes( :code )
	assert_should_require_unique_attributes( :code )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :code, :maximum => 250 )

	test "explicit Factory race test" do
		assert_difference('Race.count',1) {
			race = Factory(:race)
			assert_match /key\d*/,  race.key
			assert_match /Race\d*/, race.code
			assert_match /Desc\d*/, race.description
		}
	end

	test "should return name as to_s" do
		race = create_race
		assert_equal race.name, "#{race}"
	end

#protected
#
#	def create_race(options={})
#		race = Factory.build(:race,options)
#		race.save
#		race
#	end

end
