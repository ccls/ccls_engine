require 'test_helper'

class Ccls::ZipCodeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_unique_attribute(:zip_code)

	[ :zip_code, :latitude, :longitude, :city, :state, :county, :zip_class ].each do |f|
		assert_should_require_attributes(f)
	end

	%w( zip_code ).each do |f|
		assert_should_require_attribute_length( f.to_sym, :is => 5 )
	end

	%w( city state county zip_class ).each do |f|
		assert_should_require_attribute_length( f.to_sym, :maximum => 250 )
	end

#	test "should return name as to_s" do
#		object = create_object
#		assert_equal object.name, "#{object}"
#	end

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
