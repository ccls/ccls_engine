require 'test_helper'

class Ccls::ProjectTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_have_many( :instrument_types, :enrollments, :instruments, :gift_cards )
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position, :began_on, :ended_on, 
		:eligibility_criteria )
	assert_should_habtm( :samples )
	assert_should_act_as_list
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_attribute_length( :description, :in => 4..250 )

	assert_requires_complete_date( :began_on, :ended_on )


	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should have many study_subjects through enrollments" do
		object = create_object
		assert_equal 0, object.study_subjects.length
		Factory(:enrollment, :project_id => object.id)
		assert_equal 1, object.reload.study_subjects.length
		Factory(:enrollment, :project_id => object.id)
		assert_equal 2, object.reload.study_subjects.length
	end

	test "should find by code with ['string']" do
		object = Project['HomeExposures']
		assert object.is_a?(Project)
	end

	test "should find by code with [:symbol]" do
		object = Project[:HomeExposures]
		assert object.is_a?(Project)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(Project::NotFound) {
#			object = Project['idonotexist']
#		}
#	end

	#	this method seems like it would be better suited to 
	#	be in the StudySubject model rather than Project
	test "should return projects not enrolled by given study_subject" do
		study_subject = create_study_subject
		unenrolled = Project.unenrolled_projects(study_subject)
		assert_not_nil unenrolled
		assert unenrolled.is_a?(Array)
		assert_equal 8, unenrolled.length
	end

end
