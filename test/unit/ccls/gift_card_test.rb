require 'test_helper'

class Ccls::GiftCardTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:study_subject, :project)
	assert_should_protect( :study_subject_id, :study_subject )
	assert_should_require_attributes(:number)
	assert_should_require_unique_attributes(:number)
	assert_should_not_require_attributes( :study_subject_id,
		:project_id,
		:issued_on,
		:expiration,
		:vendor )
	assert_should_require_attribute_length( :expiration,
		:vendor,
		:number, 
			:maximum => 250 )

	test "explicit Factory gift_card test" do
		assert_difference('GiftCard.count',1) {
			gift_card = Factory(:gift_card)
			assert_match /\d*/, gift_card.number
		}
	end

	test "should return number as to_s" do
		gift_card = create_gift_card
		assert_equal gift_card.number, "#{gift_card}"
	end

#protected
#
#	def create_gift_card(options={})
#		gift_card = Factory.build(:gift_card,options)
#		gift_card.save
#		gift_card
#	end

end
