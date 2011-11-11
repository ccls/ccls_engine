require 'test_helper'

class Ccls::SubjectRelationshipTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_should_require_attribute_length( :code, :maximum => 250 )

	test "explicit Factory subject_relationship test" do
		assert_difference('SubjectRelationship.count',1) {
			subject_relationship = Factory(:subject_relationship)
			assert_match /Code\d*/, subject_relationship.code
			assert_match /Desc\d*/, subject_relationship.description
		}
	end

	test "should return description as to_s" do
		subject_relationship = create_subject_relationship
		assert_equal subject_relationship.description, "#{subject_relationship}"
	end

	test "should find by code with ['string']" do
		subject_relationship = SubjectRelationship['unknown']
		assert subject_relationship.is_a?(SubjectRelationship)
	end

	test "should find by code with [:symbol]" do
		subject_relationship = SubjectRelationship[:unknown]
		assert subject_relationship.is_a?(SubjectRelationship)
	end

	test "should find random" do
		subject_relationship = SubjectRelationship.random()
		assert subject_relationship.is_a?(SubjectRelationship)
	end

	test "should return nil on random when no records" do
		SubjectRelationship.stubs(:count).returns(0)
		subject_relationship = SubjectRelationship.random()
		assert_nil subject_relationship
	end

#protected
#
#	def create_subject_relationship(options={})
#		subject_relationship = Factory.build(:subject_relationship,options)
#		subject_relationship.save
#		subject_relationship
#	end

end
