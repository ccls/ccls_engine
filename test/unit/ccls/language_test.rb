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
		language = Language['english']
		assert language.is_a?(Language)
	end

	test "should find by key with [:symbol]" do
		language = Language[:english]
		assert language.is_a?(Language)
	end

	test "should return description as to_s" do
		language = create_language
		assert_equal language.description, "#{language}"
	end

	test "should find random" do
		language = Language.random()
		assert language.is_a?(Language)
	end

	test "should return nil on random when no records" do
		Language.stubs(:count).returns(0)
		language = Language.random()
		assert_nil language
	end

protected

	def create_language(options={})
		language = Factory.build(:language,options)
		language.save
		language
	end

end
