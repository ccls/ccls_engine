require 'test_helper'

#	This is just a collection of abstract related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectAbstractsTest < ActiveSupport::TestCase

	assert_should_have_many( :abstracts, :model => 'StudySubject')

	test "should NOT destroy abstracts with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Abstract.count',1) {
			@study_subject = Factory(:study_subject)
			Factory(:abstract, :study_subject => @study_subject)
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Abstract.count',0) {
			@study_subject.destroy
		} }
	end

	test "should raise StudySubject::NotTwoAbstracts with 0 abstracts" <<
			" on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		assert_equal 0, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstracts_the_same?
		}
	end

	test "should raise StudySubject::NotTwoAbstracts with 1 abstracts" <<
			" on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 1, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstracts_the_same?
		}
	end

	test "should return true if abstracts are the same on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 2, study_subject.abstracts.length
		assert study_subject.abstracts_the_same?
	end

	test "should raise StudySubject::NotTwoAbstracts with 3 abstracts" <<
			" on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 3, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstracts_the_same?
		}
	end

	test "should raise StudySubject::NotTwoAbstracts with 0 abstracts" <<
			" on abstract_diffs" do
		study_subject = Factory(:study_subject)
		assert_equal 0, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstract_diffs
		}
	end

	test "should raise StudySubject::NotTwoAbstracts with 1 abstracts" <<
			" on abstract_diffs" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 1, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstract_diffs
		}
	end

	test "should return true if abstracts are the same on abstract_diffs" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 2, study_subject.abstracts.length
		assert_equal Hash.new, study_subject.abstract_diffs
		assert       study_subject.abstract_diffs.empty?
	end

	test "should raise StudySubject::NotTwoAbstracts with 3 abstracts" <<
			" on abstract_diffs" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 3, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstract_diffs
		}
	end

protected

	def create_object
		study_subject = Factory.build(:study_subject)
		study_subject.save
		study_subject
	end

end
