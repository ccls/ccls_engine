require 'test_helper'

class Ccls::SectionTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:follow_ups)
	assert_should_not_require_attributes( :position )
#	assert_should_require_attribute_length( :event_category, :in => 4..250 )

	test "explicit Factory section test" do
		assert_difference('Section.count',1) {
			section = Factory(:section)
			assert_match /Key\d*/, section.key
			assert_match /Desc\d*/, section.description
		}
	end

	test "should return description as to_s" do
		section = create_section
		assert_equal section.description, "#{section}"
	end

#protected
#
#	def create_section(options={})
#		section = Factory.build(:section,options)
#		section.save
#		section
#	end

end
