require 'test_helper'

#	This is just a collection of race related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectRaceTest < ActiveSupport::TestCase

	test "should create study_subject with race" do
		assert_difference( 'Race.count', 1 ){
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject
			study_subject.races << Factory(:race)
			assert !study_subject.new_record?,
				"#{study_subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should NOT destroy races with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Race.count',1) {
			@study_subject = Factory(:subject_race).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Race.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy subject_races with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('SubjectRace.count',1) {
			@study_subject = Factory(:subject_race).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('SubjectRace.count',0) {
			@study_subject.destroy
		} }
	end

	test "should return race name for string" do
		study_subject = create_study_subject
		assert_equal study_subject.race_names, 
			"#{study_subject.races.first}"
	end

	test "should create study_subject with empty subject_races_attributes" do
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => { })
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
	end

	test "should create study_subject with blank race_id" do
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => { 
				'0' => { :race_id => '' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
	end

	test "should create study_subject with subject_races_attributes race_id" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				'0' => { :race_id => Race.first.id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert !@study_subject.subject_races.empty?
		assert !@study_subject.subject_races.first.is_primary
	end

	test "should create study_subject with subject_races_attributes race_id and is_primary" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				'0' => { :race_id => Race.first.id, :is_primary => 'true' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert !@study_subject.subject_races.empty?
		assert  @study_subject.subject_races.first.is_primary
	end

	test "should create study_subject with subject_races_attributes multiple races" do
		assert Race.count > 2
		races = Race.all
		assert_difference( 'SubjectRace.count', 3 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				'0' => { :race_id => races[1].id },
				'1' => { :race_id => races[2].id },
				'2' => { :race_id => races[3].id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert_equal 3, @study_subject.races.length
		assert !@study_subject.subject_races.empty?
		assert_equal 3, @study_subject.subject_races.length
		assert !@study_subject.subject_races.collect(&:is_primary).any?
	end

	test "should create study_subject with subject_races_attributes multiple races and is_primaries" do
		assert Race.count > 2
		races = Race.all
		assert_difference( 'SubjectRace.count', 3 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				'0' => { :race_id => races[1].id, :is_primary => 'true' },
				'1' => { :race_id => races[2].id, :is_primary => 'true' },
				'2' => { :race_id => races[3].id, :is_primary => 'true' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert_equal 3, @study_subject.races.length
		assert !@study_subject.subject_races.empty?
		assert_equal 3, @study_subject.subject_races.length
		assert  @study_subject.subject_races.collect(&:is_primary).all?
	end

	test "should create study_subject with subject_races_attributes with is_primary and no race_id" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				'0' => { :is_primary => 'true' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
	end

	test "should NOT create study_subject with subject_races_attributes " <<
			"if race is other and no other given" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 0 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				'0' => { :race_id => Race['other'].id }
			})
			assert @study_subject.errors.on_attr_and_type?("subject_races.other",:blank)
		} }
	end

	test "should update study_subject with subject_races_attributes" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "StudySubject.count", 0 ) {
			@study_subject.update_attributes(:subject_races_attributes => {
				'0' => { :race_id => Race.first.id, :is_primary => 'true' }
			})
		} }
		assert !@study_subject.races.empty?
		assert !@study_subject.subject_races.empty?
		assert  @study_subject.subject_races.first.is_primary
	end

	test "should destroy subject_race on update with _destroy" do
		study_subject = create_study_subject
		assert_difference( 'SubjectRace.count', 1 ){
			study_subject.update_attributes(:subject_races_attributes => {
				'0' => { :race_id => Race.first.id, :is_primary => 'true' }
			})
		}
		subject_race = study_subject.subject_races.first
		assert_difference( 'SubjectRace.count', -1 ){
			study_subject.update_attributes(:subject_races_attributes => {
				'0' => { :id => subject_race.id, :_destroy => 1 }
			})
		}
	end

protected

#	def assert_no_duplicates_found
#		assert_not_nil @duplicates
#		assert @duplicates.is_a?(Array)
#		assert @duplicates.empty?
#	end
#
#	def assert_duplicates_found
#		assert_not_nil @duplicates
#		assert @duplicates.is_a?(Array)
#		assert !@duplicates.empty?
#	end
#
##	def create_study_subject(options={})
##		study_subject = Factory.build(:study_subject,options)
##		study_subject.save
##		study_subject
##	end
#
#	def create_study_subject_with_matchingid(matchingid='12345')
#		study_subject = create_study_subject( 
#			:identifier_attributes => Factory.attributes_for(:identifier,
#				{ :matchingid => matchingid })).reload
#	end
#
#	def create_case_study_subject_for_duplicate_search(options={})
#		Factory(:case_study_subject, { :sex => 'M',
#			:pii_attributes => Factory.attributes_for(:pii,
#				:dob => Date.yesterday),
##	we no longer need the identifier in the check since hospital_no moved
##			:identifier_attributes => Factory.attributes_for(:identifier),
#			:patient_attributes => Factory.attributes_for(:patient,
#				:hospital_no => 'matchthis',
#				:admit_date => Date.yesterday ) }.deep_merge(options) )
#	end
#
#	def new_case_study_subject_for_duplicate_search(options={})
#		Factory.build(:case_study_subject, { :sex => 'F',
#			:pii_attributes => Factory.attributes_for(:pii,
#				:dob => Date.today),
##	we no longer need the identifier in the check since hospital_no moved
##			:identifier_attributes => Factory.attributes_for(:identifier),
#			:patient_attributes => Factory.attributes_for(:patient,
#				:hospital_no => 'somethingdifferent',
##				:organization_id => 0,	#	Why 0? was for just matching admit_date
#				:admit_date => Date.today ) }.deep_merge(options) )
#	end
#
#	#	Used more than once so ...
#	def create_case_study_subject_with_patient_and_identifier
#		study_subject = create_case_study_subject( 
#			:patient_attributes    => Factory.attributes_for(:patient,
#				{ :admit_date => Date.yesterday }),
#			:identifier_attributes => Factory.attributes_for(:identifier,
#				{ :matchingid => '12345' })).reload
#		assert_not_nil study_subject.reference_date
#		assert_not_nil study_subject.patient.admit_date
#		assert_equal study_subject.reference_date, study_subject.patient.admit_date
#		study_subject
#	end

end
