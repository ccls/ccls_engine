require File.dirname(__FILE__) + '/../../test_helper'

class Ccls::PhotoTest < ActiveSupport::TestCase

	assert_should_require(:title,
		:model => 'Photo')

	test "should create photo" do
		assert_difference 'Photo.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:photo,options)
		record.save
		record
	end

end
