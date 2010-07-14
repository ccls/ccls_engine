require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < ActiveSupport::TestCase

	test "should create image" do
		assert_difference 'Image.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:image,options)
		record.save
		record
	end

end
