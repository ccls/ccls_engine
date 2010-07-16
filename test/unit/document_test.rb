require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < ActiveSupport::TestCase

	assert_should_require(:title)

	test "should create document" do
		assert_difference 'Document.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:document,options)
		record.save
		record
	end

end
