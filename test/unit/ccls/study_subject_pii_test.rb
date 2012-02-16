require 'test_helper'

#	TODO these tests will need implemented somehow

#	This is just a collection of pii related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectPiiTest < ActiveSupport::TestCase
#
#	test "should create study_subject and accept_nested_attributes_for pii" do
#		assert_difference( 'Pii.count', 1) {
#		assert_difference( "StudySubject.count", 1 ) {
#			study_subject = create_study_subject(
#				:pii_attributes => Factory.attributes_for(:pii))
#			assert !study_subject.new_record?, 
#				"#{study_subject.errors.full_messages.to_sentence}"
#		} }
#	end
#
#	test "should NOT create study_subject with empty pii" do
#		assert_difference( 'Pii.count', 0) {
#		assert_difference( "StudySubject.count", 0 ) {
#			study_subject = create_study_subject( :pii_attributes => {})
#			assert study_subject.errors.on_attr_and_type?('pii.dob',:blank)
#		} }
#	end
#
#	test "should NOT destroy pii with study_subject" do
#		assert_difference('StudySubject.count',1) {
#		assert_difference('Pii.count',1) {
#			@study_subject = Factory(:pii).study_subject
#		} }
#		assert_difference('StudySubject.count',-1) {
#		assert_difference('Pii.count',0) {
#			@study_subject.destroy
#		} }
#	end
#
#	#	Delegated pii fields except ... first_name, last_name, mother_maiden_name
#	%w( initials fathers_name mothers_name email dob ).each do |method_name|
#
#		test "should return nil #{method_name} without pii" do
#			study_subject = create_study_subject
#			assert_nil study_subject.send(method_name)
#		end
#
#		test "should return #{method_name} with pii" do
#			study_subject = create_study_subject(
#				:pii_attributes => Factory.attributes_for(:pii))
#			assert_not_nil study_subject.send(method_name)
#		end
#
#	end

	test "should be ineligible for invitation without email" do
		study_subject = create_study_subject(:email => nil)
		assert_nil study_subject.email
		assert !study_subject.is_eligible_for_invitation?
	end

	test "should be eligible for invitation with email" do
		study_subject = create_study_subject
		assert_not_nil study_subject.email
		assert study_subject.is_eligible_for_invitation?
	end

	test "should return 'name not available' for study_subject without names" do
		study_subject = create_study_subject
		assert_nil study_subject.first_name
		assert_nil study_subject.middle_name
		assert_nil study_subject.last_name
		assert_equal '[name not available]', study_subject.full_name
	end

	test "should not require dob on creation for mother with flag" do
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_type => SubjectType['Mother'],
#				:pii_attributes => Factory.attributes_for(:pii,
					:subject_is_mother => true,
					:dob => nil )
#			)
		}
		assert_nil @study_subject.reload.dob
	end

	test "should not require dob on update for mother" do
		#	flag not necessary as study_subject.subject_type exists
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_type => SubjectType['Mother'] )
#				:pii_attributes => Factory.attributes_for(:pii) )
		}
		assert_not_nil @study_subject.reload.dob
#		@study_subject.pii.update_attributes(:dob => nil)
		@study_subject.update_attributes(:dob => nil)
		assert_nil @study_subject.reload.dob
	end

end
