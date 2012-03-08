require 'test_helper'

class Ccls::StudySubjectSearchTest < ActiveSupport::TestCase

	test "should return StudySubjectSearch" do
		assert StudySubjectSearch().is_a?(StudySubjectSearch)
	end 

	test "should respond to search" do
		assert StudySubject.respond_to?(:search)
	end

	test "should return Array" do
		study_subjects = StudySubject.search()
		assert study_subjects.is_a?(Array)
	end

	test "should include study_subject" do
		study_subject = create_study_subject
		study_subjects = StudySubject.search()
		assert study_subjects.include?(study_subject)
	end

	test "should include study_subject without pagination" do
		study_subject = create_study_subject
		study_subjects = StudySubject.search(:paginate => false)
		assert study_subjects.include?(study_subject)
	end

	test "should include study_subject by subject_types" do
		s1,s2,s3 = create_study_subjects(3)
		study_subjects = StudySubject.search(
			:types => [s1,s2].collect{|s|s.subject_type.description})
		assert  study_subjects.include?(s1)
		assert  study_subjects.include?(s2)
		assert !study_subjects.include?(s3)
	end

	test "should include study_subject by races" do
		s1,s2,s3 = nil
		assert_difference('StudySubject.count',3) do
			s1,s2,s3 = create_study_subjects_with_races(3)
		end
		study_subjects = StudySubject.search(
			:races => [s1,s2].collect{|s|s.races.first.name})
		assert  study_subjects.include?(s1)
		assert  study_subjects.include?(s2)
		assert !study_subjects.include?(s3)
	end

#	Don't think that this'll need to be searchable
#	test "should include study_subject by hispanicity" do
#		s1,s2,s3 = create_study_subjects(3)
#pending
#		study_subjects = StudySubject.search(
#			:races => [s1,s2].collect{|s|s.race.name})
#		assert  study_subjects.include?(s1)
#		assert  study_subjects.include?(s2)
#		assert !study_subjects.include?(s3)
#	end

	test "should include study_subject by vital_statuses" do
		s1,s2,s3 = create_study_subjects(3)
		study_subjects = StudySubject.search(
			:vital_statuses => [s1,s2].collect{|s|s.vital_status.key})
		assert  study_subjects.include?(s1)
		assert  study_subjects.include?(s2)
		assert !study_subjects.include?(s3)
	end

#	test "should include all study_subjects and ignore dust kits" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_study_subject
#		study_subjects = StudySubject.search(:dust_kit => 'ignore')
#		assert study_subjects.include?(subject1)
#		assert study_subjects.include?(subject2)
#	end

#	test "should include study_subjects with no dust kits" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_study_subject
#		study_subjects = StudySubject.search(:dust_kit => 'none')
#		assert  study_subjects.include?(subject2)
#		assert !study_subjects.include?(subject1)
#	end

#	test "should include study_subject with dust kit" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_study_subject
#		study_subjects = StudySubject.search(:dust_kit => 'shipped')
#		assert  study_subjects.include?(subject1)
#		assert !study_subjects.include?(subject2)
#	end

#	test "should include study_subject with dust kit delivered to study_subject" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		dust_kit.kit_package.update_attributes(:status => 'Delivered')
#		subject2 = create_study_subject
#		create_dust_kit(:study_subject_id => subject2.id)
#		study_subjects = StudySubject.search(:dust_kit => 'delivered')
#		assert  study_subjects.include?(subject1)
#		assert !study_subjects.include?(subject2)
#	end

#	test "should include study_subject with dust kit returned to us" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		dust_kit.dust_package.update_attributes(:status => 'Transit')
#		subject2 = create_study_subject
#		create_dust_kit(:study_subject_id => subject2.id)
#		study_subjects = StudySubject.search(:dust_kit => 'returned')
#		assert  study_subjects.include?(subject1)
#		assert !study_subjects.include?(subject2)
#	end

#	test "should include study_subject with dust kit received by us" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		dust_kit.dust_package.update_attributes(:status => 'Delivered')
#		subject2 = create_study_subject
#		create_dust_kit(:study_subject_id => subject2.id)
#		study_subjects = StudySubject.search(:dust_kit => 'received')
#		assert  study_subjects.include?(subject1)
#		assert !study_subjects.include?(subject2)
#	end

#	#	There was a problem doing finds which included joins
#	#	which included both named joins and sql fragment strings.
#	#	It should work, but didn't and required some manual
#	#	tweaking.
#	test "should work with both dust_kit string and race symbol" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_study_subject
#		study_subjects = StudySubject.search(:dust_kit => 'none', 
#			:races => [subject2.race.name] )
#		assert  study_subjects.include?(subject2)
#		assert !study_subjects.include?(subject1)
#	end

	test "should include study_subject by having project" do
		e1 = Factory(:enrollment)
		e2 = Factory(:enrollment)
		study_subjects = StudySubject.search(
			:projects => {e1.project.id => ''})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end 

	test "should include study_subject by multiple projects" do
		e1 = Factory(:enrollment)
		e2 = Factory(:enrollment,:study_subject => e1.study_subject)
		e3 = Factory(:enrollment,:project => e2.project)
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => '', 
			e2.project.id => ''
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e3.study_subject)
	end

	test "should include study_subject by project indifferent completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => YNDK[:no])
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :completed => [true,false] }
		})
		assert study_subjects.include?(e1.study_subject)
		assert study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project not completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => YNDK[:no])
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :completed => false }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project is completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => YNDK[:no])
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :completed => true }
		})
		assert !study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project indifferent closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :closed => [true,false] }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project not closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :closed => false }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project is closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :closed => true }
		})
		assert !study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project indifferent terminated" do
		e1 = Factory(:enrollment, :terminated_participation => YNDK[:no])
		e2 = Factory(:enrollment, :terminated_participation => YNDK[:yes],
			:terminated_reason => 'unknown',
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :terminated => [true,false] }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project not terminated" do
		e1 = Factory(:enrollment, :terminated_participation => YNDK[:no])
		e2 = Factory(:enrollment, :terminated_participation => YNDK[:yes],
			:terminated_reason => 'unknown',
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :terminated => false }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project is terminated" do
		e1 = Factory(:enrollment, :terminated_participation => YNDK[:no])
		e2 = Factory(:enrollment, :terminated_participation => YNDK[:yes],
			:terminated_reason => 'unknown',
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :terminated => true }
		})
		assert !study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project indifferent consented" do
		e1 = Factory(:consented_enrollment, :consented => YNDK[:no],
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:consented_enrollment, :consented => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :consented => [true,false] }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project not consented" do
		e1 = Factory(:consented_enrollment, :consented => YNDK[:no],
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:consented_enrollment, :consented => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :consented => YNDK[:no] }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project is consented" do
		e1 = Factory(:consented_enrollment, :consented => YNDK[:no],
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:consented_enrollment, :consented => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :consented => true }
		})
		assert !study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project indifferent candidate" do
		e1 = Factory(:enrollment, :is_candidate => YNDK[:no])
		e2 = Factory(:enrollment, :is_candidate => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :candidate => [true,false] }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project not candidate" do
		e1 = Factory(:enrollment, :is_candidate => YNDK[:no])
		e2 = Factory(:enrollment, :is_candidate => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :candidate => false }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project is candidate" do
		e1 = Factory(:enrollment, :is_candidate => YNDK[:no])
		e2 = Factory(:enrollment, :is_candidate => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :candidate => true }
		})
		assert !study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project indifferent chosen" do
		e1 = Factory(:enrollment, :is_chosen => YNDK[:no],
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :chosen => [true,false] }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project not chosen" do
		e1 = Factory(:enrollment, :is_chosen => YNDK[:no],
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :chosen => false }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project is chosen" do
		e1 = Factory(:enrollment, :is_chosen => YNDK[:no],
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :chosen => true }
		})
		assert !study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project indifferent eligible" do
		e1 = Factory(:enrollment, :is_eligible => YNDK[:no],
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :eligible => [true,false] }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project not eligible" do
		e1 = Factory(:enrollment, :is_eligible => YNDK[:no],
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :eligible => false }
		})
		assert  study_subjects.include?(e1.study_subject)
		assert !study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by project is eligible" do
		e1 = Factory(:enrollment, :is_eligible => YNDK[:no],
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => YNDK[:yes],
			:project => e1.project )
		study_subjects = StudySubject.search(:projects => {
			e1.project.id => { :eligible => true }
		})
		assert !study_subjects.include?(e1.study_subject)
		assert  study_subjects.include?(e2.study_subject)
	end

	test "should include study_subject by complete patid" do
		s1,s2,s3 = create_study_subjects_with_patids(1234,5678,9)
		study_subjects = StudySubject.search(:patid => 5678)
		assert !study_subjects.include?(s1)
		assert  study_subjects.include?(s2)
		assert !study_subjects.include?(s3)
	end

	test "should NOT order by bogus column with dir" do
		s1,s2,s3 = create_study_subjects(3)
		study_subjects = StudySubject.search(
			:order => 'whatever', :dir => 'asc')
		assert_equal [s1,s2,s3], study_subjects
	end

	test "should NOT order by bogus column" do
		s1,s2,s3 = create_study_subjects(3)
		study_subjects = StudySubject.search(:order => 'whatever')
		assert_equal [s1,s2,s3], study_subjects
	end

	test "should order by priority asc by default" do
		project,s1,s2,s3 = create_study_subjects_with_recruitment_priorities(9,3,6)
		study_subjects = StudySubject.search(:order => 'priority',
			:projects=>{ project.id => {} })
		assert_equal [s2,s3,s1], study_subjects
	end

	test "should order by priority asc" do
		project,s1,s2,s3 = create_study_subjects_with_recruitment_priorities(9,3,6)
		study_subjects = StudySubject.search(:order => 'priority',
			:dir => 'asc',
			:projects=>{ project.id => {} })
		assert_equal [s2,s3,s1], study_subjects
	end

	test "should order by priority desc" do
		project,s1,s2,s3 = create_study_subjects_with_recruitment_priorities(9,3,6)
		study_subjects = StudySubject.search(:order => 'priority',:dir => 'desc',
			:projects=>{ project.id => {} })
		assert_equal [s1,s3,s2], study_subjects
	end

	test "should order by id asc by default" do
		s1,s2,s3 = create_study_subjects_with_childids(9,3,6)
		study_subjects = StudySubject.search(
			:order => 'id')
		assert_equal [s1,s2,s3], study_subjects
	end

	test "should order by id asc" do
		s1,s2,s3 = create_study_subjects_with_childids(9,3,6)
		study_subjects = StudySubject.search(
			:order => 'id', :dir => 'asc')
		assert_equal [s1,s2,s3], study_subjects
	end

	test "should order by id desc" do
		s1,s2,s3 = create_study_subjects_with_childids(9,3,6)
		study_subjects = StudySubject.search(
			:order => 'id', :dir => 'desc')
		assert_equal [s3,s2,s1], study_subjects
	end


#	TODO put these back if necessary
#			sent_to_subject_on received_by_ccls_at
#	will need a rather complex join added though.

	%w( childid patid studyid dob first_name last_name 
			sample_outcome interview_outcome_on 
			sample_outcome_on
			).each do |column|
		test "should order by #{column} asc by default" do
			s1,s2,s3 = send("three_study_subjects_with_#{column}")
			study_subjects = StudySubject.search(:order => column)
			assert_equal 3, study_subjects.length
			assert_equal [s2,s3,s1], study_subjects
		end

		test "should order by #{column} asc" do
			s1,s2,s3 = send("three_study_subjects_with_#{column}")
			study_subjects = StudySubject.search(:order => column, :dir => 'asc')
			assert_equal 3, study_subjects.length
			assert_equal [s2,s3,s1], study_subjects
		end

		test "should order by #{column} desc" do
			s1,s2,s3 = send("three_study_subjects_with_#{column}")
			study_subjects = StudySubject.search(:order => column, :dir => 'desc')
			assert_equal 3, study_subjects.length
			assert_equal [s1,s3,s2], study_subjects
		end
	end

#	#	There was a problem doing finds which included joins
#	#	which included both sql join fragment strings and an order.
#	test "should work with both dust_kit string and order" do
#		subject1 = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_study_subject
#		study_subjects = StudySubject.search(:dust_kit => 'none', 
#			:order => 'childid')
#		assert  study_subjects.include?(subject2)
#		assert !study_subjects.include?(subject1)
#	end

	test "should include study_subject by q first_name" do
		s1,s2 = create_study_subjects_with_first_names('Michael','Bob')
		study_subjects = StudySubject.search(:q => 'mi ch ha')
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subject by q last_name" do
		s1,s2 = create_study_subjects_with_last_names('Michael','Bob')
		study_subjects = StudySubject.search(:q => 'cha ael')
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subject by q childid" do
		s1,s2 = create_study_subjects_with_childids(999999,'1')
		study_subjects = StudySubject.search(:q => s1.childid)
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subject by q patid" do
		s1,s2 = create_study_subjects_with_patids(999999,'1')
		study_subjects = StudySubject.search(:q => s1.reload.patid)
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subject by q gift_card" do
		s1,s2 = create_study_subjects_with_gift_card_numbers('9999','1111')
		study_subjects = StudySubject.search(:q => s1.gift_cards.first.number,
			:search_gift_cards => true)
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subject by has_gift_card == true" do
		s1 = create_study_subject_with_gift_card_number('9999')
		s2 = create_study_subject
		study_subjects = StudySubject.search(:has_gift_card => true,
			:search_gift_cards => true)
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subject by has_gift_card == false" do
		s1 = create_study_subject_with_gift_card_number('9999')
		s2 = create_study_subject
		study_subjects = StudySubject.search(:has_gift_card => false,
			:search_gift_cards => true)
		assert !study_subjects.include?(s1)
		assert  study_subjects.include?(s2)
	end

#	test "should return dust_kit_status of None" do
#		study_subject = create_study_subject
#		assert_equal 'None', study_subject.dust_kit_status
#	end

#	test "should return dust_kit_status of New" do
#		study_subject = create_study_subject
#		dust_kit = create_dust_kit(:study_subject_id => study_subject.id)
#		assert_equal 'New', study_subject.dust_kit_status
#	end

	test "should include study_subjects with complete sample" do
		s1 = create_hx_study_subject
		s1.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Complete'])
		s2 = create_study_subject
		s2.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Pending'])
		s3 = create_study_subject
		study_subjects = StudySubject.search(:sample_outcome => 'Complete')
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
		assert !study_subjects.include?(s3)
	end

	test "should include study_subjects with incomplete sample" do
		s1 = create_hx_study_subject
		s1.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Complete'])
		s2 = create_study_subject
		s2.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Pending'])
		s3 = create_study_subject
		study_subjects = StudySubject.search(:sample_outcome => 'Incomplete')
		assert !study_subjects.include?(s1)
		assert  study_subjects.include?(s2)
		assert  study_subjects.include?(s3)
	end

	test "should include study_subjects with complete interview" do
		s1 = create_hx_study_subject
		s1.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Complete'])
		s2 = create_study_subject
		s2.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Incomplete'])
		s3 = create_study_subject
		study_subjects = StudySubject.search(:interview_outcome => 'Complete')
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
		assert !study_subjects.include?(s3)
	end

	test "should include study_subjects with incomplete interview" do
		s1 = create_hx_study_subject
		s1.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Complete'])
		s2 = create_study_subject
		s2.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Incomplete'])
		s3 = create_study_subject
		study_subjects = StudySubject.search(:interview_outcome => 'Incomplete')
		assert !study_subjects.include?(s1)
		assert  study_subjects.include?(s2)
		assert  study_subjects.include?(s3)
	end




	test "should include study_subjects by abstracts_count = 0" do
		s1 = Factory(:case_study_subject)
		assert_equal 0, s1.abstracts_count
		s2 = Factory(:study_subject)
		assert_equal 0, s2.abstracts_count
		study_subjects = StudySubject.search(:abstracts_count => 0, :types => 'Case')
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subjects by abstracts_count = 1" do
		s1 = Factory(:case_study_subject)
		assert_equal 0, s1.abstracts_count
		Factory(:abstract, :study_subject => s1)
		assert_equal 1, s1.reload.abstracts_count
		s2 = Factory(:case_study_subject)
		assert_equal 0, s2.abstracts_count
		study_subjects = StudySubject.search(:abstracts_count => 1, :types => 'Case')
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end

	test "should include study_subjects by abstracts_count = 2" do
		s1 = Factory(:case_study_subject)
		assert_equal 0, s1.abstracts_count
		Factory(:abstract, :study_subject => s1)
		assert_equal 1, s1.reload.abstracts_count
		Factory(:abstract, :study_subject => s1)
		assert_equal 2, s1.reload.abstracts_count
		s2 = Factory(:case_study_subject)
		assert_equal 0, s2.abstracts_count
		Factory(:abstract, :study_subject => s2)
		assert_equal 1, s2.reload.abstracts_count
		study_subjects = StudySubject.search(:abstracts_count => 2, :types => 'Case')
		assert  study_subjects.include?(s1)
		assert !study_subjects.include?(s2)
	end



protected

#	def create_survey_response_sets
#		survey = Survey.find_by_access_code("home_exposure_survey")
#		rs1 = fill_out_survey(:survey => survey)
#		rs2 = fill_out_survey(:survey => survey,
#			:study_subject => rs1.study_subject)
#		[rs1.reload,rs2.reload]
#	end

end
