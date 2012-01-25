require 'test_helper'

#	This is just a collection of identifier related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectIdentifierTest < ActiveSupport::TestCase

	test "should create study_subject and accept_nested_attributes_for identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( 'StudySubject.count', 1) {
			study_subject = create_study_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	#	StudySubject currently accepts nested attributes for identifier,
	#	but an empty identifier is no longer invalid.
	test "should create study_subject with empty identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( 'StudySubject.count', 1) {
			study_subject = create_study_subject( :identifier_attributes => {} )
			assert_not_nil study_subject.identifier.subjectid
		} }
	end

	test "studyid should be patid, case_control_type and orderno" do
		Identifier.any_instance.stubs(:get_next_patid).returns('123')
		study_subject = Factory(:case_identifier).reload.study_subject
#	why unstub here?
#		Identifier.any_instance.unstub(:get_next_patid)
		assert_not_nil study_subject.studyid
		assert_not_nil study_subject.identifier.studyid
		assert_nil study_subject.identifier.studyid_nohyphen
		assert_nil study_subject.identifier.studyid_intonly_nohyphen
		assert_equal "0123-C-0", study_subject.studyid
	end

	test "should NOT destroy identifier with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Identifier.count',1) {
			@study_subject = Factory(:identifier).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Identifier.count',0) {
			@study_subject.destroy
		} }
	end

	#	Mostly delegated identifier fields except ... patid, orderno, case_control_type
	%w( childid state_id_no state_registrar_no local_registrar_no
		).each do |method_name|

		test "should return nil #{method_name} without identifier" do
			study_subject = create_study_subject
			assert_nil study_subject.send(method_name)
		end

		test "should return #{method_name} with identifier" do
			study_subject = create_study_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert_not_nil study_subject.send(method_name)
		end

	end

	test "should create study subject with specified matchingid" do
		#	just to make sure that this method is defined
		#	get funny errors when accidentally comment out.
		assert_difference('StudySubject.count',1) {
			study_subject = create_study_subject_with_matchingid('54321')
			assert_equal '054321', study_subject.reload.identifier.matchingid
		}
	end

	test "should not assign icf_master_id when there are none" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject.assign_icf_master_id
		assert_nil study_subject.identifier.icf_master_id
	end

	test "should not assign icf_master_id if already have one and one exists" do
		study_subject = create_identifier.study_subject
		assert_nil study_subject.identifier.reload.icf_master_id
		imi1 = Factory(:icf_master_id,:icf_master_id => '12345678A')
		study_subject.assign_icf_master_id
		assert_equal imi1.icf_master_id, study_subject.identifier.reload.icf_master_id
		imi2 = Factory(:icf_master_id,:icf_master_id => '12345678B')
		study_subject.assign_icf_master_id
		assert_equal imi1.icf_master_id, study_subject.identifier.reload.icf_master_id

#		study_subject = create_identifier.study_subject
#		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
#		icf_master_id = study_subject.identifier.reload.icf_master_id
#		assert_not_nil icf_master_id
#		study_subject.assign_icf_master_id
#		assert_equal icf_master_id, study_subject.identifier.reload.icf_master_id
	end

	test "should assign icf_master_id when there is one" do
#		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject = create_identifier.study_subject
		imi = Factory(:icf_master_id,:icf_master_id => '12345678A')
		study_subject.assign_icf_master_id
		assert_not_nil study_subject.identifier.icf_master_id
		assert_equal '12345678A', study_subject.identifier.icf_master_id
		imi.reload
		assert_not_nil imi.assigned_on
		assert_equal Date.today, imi.assigned_on
		assert_not_nil imi.study_subject_id
		assert_equal imi.study_subject_id, study_subject.id
	end

	test "should assign icf_master_id to mother on creation if one exists" do
#		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject = create_identifier.study_subject
		imi = Factory(:icf_master_id,:icf_master_id => '12345678A')
		assert_equal '12345678A', imi.icf_master_id
		mother = study_subject.create_mother
		assert_not_nil mother.reload.identifier.icf_master_id
		assert_equal '12345678A', mother.icf_master_id
		assert_equal '12345678A', mother.identifier.icf_master_id
	end

	test "should not assign icf_master_id to mother on creation if none exist" do
#		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject = create_identifier.study_subject
		mother = study_subject.create_mother
		assert_nil mother.reload.identifier.icf_master_id
	end

	test "should return 'no ID assigned' if study_subject has no icf_master_id" do
#		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject = create_identifier.study_subject
		assert_nil     study_subject.identifier.icf_master_id
		assert_not_nil study_subject.icf_master_id
		assert_equal   study_subject.icf_master_id, '[no ID assigned]'
	end

	test "should return icf_master_id if study_subject has icf_master_id" do
		study_subject = create_identifier.study_subject
		assert_nil     study_subject.identifier.icf_master_id
		assert_not_nil study_subject.icf_master_id
		assert_equal   study_subject.icf_master_id, '[no ID assigned]'
#		assert_equal   study_subject.icf_master_id, study_subject.identifier.icf_master_id
		imi = Factory(:icf_master_id,:icf_master_id => '12345678A')
		study_subject.assign_icf_master_id
		assert_not_nil study_subject.identifier.icf_master_id
		assert_not_nil study_subject.icf_master_id
		assert_equal   study_subject.icf_master_id, study_subject.identifier.icf_master_id
		assert_equal   study_subject.icf_master_id, imi.icf_master_id
	end

	test "should assign icf_master_id to father on creation if one exists" do
#		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject = create_identifier.study_subject
		imi = Factory(:icf_master_id,:icf_master_id => '12345678A')
		father = study_subject.create_father
		assert_not_nil father.reload.identifier.icf_master_id
		assert_equal '12345678A', father.icf_master_id
		assert_equal '12345678A', father.identifier.icf_master_id
	end

	test "should not assign icf_master_id to father on creation if none exist" do
#		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject = create_identifier.study_subject
		father = study_subject.create_father
		assert_nil father.reload.identifier.icf_master_id
	end

protected

	def create_study_subject_with_matchingid(matchingid='12345')
		study_subject = create_study_subject( 
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => matchingid })).reload
	end

end
