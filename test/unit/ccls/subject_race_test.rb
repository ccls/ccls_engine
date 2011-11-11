require 'test_helper'

class Ccls::SubjectRaceTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to( :study_subject, :race )

	test "explicit Factory subject_race test" do
		assert_difference('Race.count',1) {
		assert_difference('StudySubject.count',1) {
		assert_difference('SubjectRace.count',1) {
			subject_race = Factory(:subject_race)
			assert_not_nil subject_race.study_subject
			assert_not_nil subject_race.race
		} } }
	end

end
