require 'test_helper'

#
#	FYI, csv fixture files do not allow for comments
#
class Ccls::ZipCodeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_unique_attribute(:zip_code)
	assert_should_belong_to(:county)
	assert_should_require_attributes( :zip_code, :city, :state, :zip_class )
	assert_should_require_attribute_length( :zip_code, :is => 5 )
	assert_should_require_attribute_length( :city, :state, :zip_class,
		:maximum => 250 )

	test "should return city, state zip as to_s" do
		object = create_object
		assert_equal "#{object.city}, #{object.state} #{object.zip_code}", "#{object}"
	end

	test "should not find non-existant zip code with ['string']" do
		assert_nil ZipCode['94700']
	end

	test "should find by zip code with ['string']" do
		Factory(:zip_code,:zip_code => '94700')
		object = ZipCode['94700']
		assert object.is_a?(ZipCode)
	end

	test "should find by zip code with [:symbol]" do
		Factory(:zip_code,:zip_code => '94700')
		object = ZipCode['94700'.to_sym]	#	:1 is no good, but '1'.to_sym is OK
		assert object.is_a?(ZipCode)
	end

end
