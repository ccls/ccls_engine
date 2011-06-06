require 'test_helper'

class Ccls::LanguageTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :interviews, :instrument_versions )
	assert_should_require_attributes( :key, :code, :description )
	assert_should_require_unique_attributes( :key, :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :key, :code, 
		:maximum => 250 )
	assert_should_require_attribute_length( :description, :in => 4..250 )

	test "should find by key with ['string']" do
		object = Language['english']
		assert object.is_a?(Language)
	end

	test "should find by key with [:symbol]" do
		object = Language[:english]
		assert object.is_a?(Language)
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find random" do
		object = Language.random()
		assert object.is_a?(Language)
	end

	test "should return nil on random when no records" do
		Language.stubs(:count).returns(0)
		object = Language.random()
		assert_nil object
	end

end
