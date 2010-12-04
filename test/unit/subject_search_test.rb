require File.dirname(__FILE__) + '/../test_helper'

class SubjectSearchTest < ActiveSupport::TestCase

	test "should return SubjectSearch" do
		assert SubjectSearch().is_a?(SubjectSearch)
	end 

	test "should respond to search" do
		assert Subject.respond_to?(:search)
	end

	test "should return Array" do
		subjects = Subject.search()
		assert subjects.is_a?(Array)
	end

	test "should include subject" do
		subject = create_subject
		subjects = Subject.search()
		assert subjects.include?(subject)
	end

	test "should include subject without pagination" do
		subject = create_subject
		subjects = Subject.search(:paginate => false)
		assert subjects.include?(subject)
	end

	test "should include subject by subject_types" do
		s1,s2,s3 = create_subjects(3)
		subjects = Subject.search(
			:types => [s1,s2].collect{|s|s.subject_type.description})
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subject by races" do
		s1,s2,s3 = create_subjects(3)
		subjects = Subject.search(
			:races => [s1,s2].collect{|s|s.race.name})
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subject by hispanicity" do
		s1,s2,s3 = create_subjects(3)
pending
#		subjects = Subject.search(
#			:races => [s1,s2].collect{|s|s.race.name})
#		assert  subjects.include?(s1)
#		assert  subjects.include?(s2)
#		assert !subjects.include?(s3)
	end

	test "should include subject by vital_statuses" do
		s1,s2,s3 = create_subjects(3)
		subjects = Subject.search(
			:vital_statuses => [s1,s2].collect{|s|s.vital_status.code})
		assert  subjects.include?(s1)
		assert  subjects.include?(s2)
		assert !subjects.include?(s3)
	end

#	test "should include all subjects and ignore dust kits" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'ignore')
#		assert subjects.include?(subject1)
#		assert subjects.include?(subject2)
#	end

#	test "should include subjects with no dust kits" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'none')
#		assert  subjects.include?(subject2)
#		assert !subjects.include?(subject1)
#	end

#	test "should include subject with dust kit" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'shipped')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	test "should include subject with dust kit delivered to subject" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		dust_kit.kit_package.update_attributes(:status => 'Delivered')
#		subject2 = create_subject
#		create_dust_kit(:study_subject_id => subject2.id)
#		subjects = Subject.search(:dust_kit => 'delivered')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	test "should include subject with dust kit returned to us" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		dust_kit.dust_package.update_attributes(:status => 'Transit')
#		subject2 = create_subject
#		create_dust_kit(:study_subject_id => subject2.id)
#		subjects = Subject.search(:dust_kit => 'returned')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	test "should include subject with dust kit received by us" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		dust_kit.dust_package.update_attributes(:status => 'Delivered')
#		subject2 = create_subject
#		create_dust_kit(:study_subject_id => subject2.id)
#		subjects = Subject.search(:dust_kit => 'received')
#		assert  subjects.include?(subject1)
#		assert !subjects.include?(subject2)
#	end

#	#	There was a problem doing finds which included joins
#	#	which included both named joins and sql fragment strings.
#	#	It should work, but didn't and required some manual
#	#	tweaking.
#	test "should work with both dust_kit string and race symbol" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'none', 
#			:races => [subject2.race.name] )
#		assert  subjects.include?(subject2)
#		assert !subjects.include?(subject1)
#	end

	test "should include subject by having project" do
		e1 = Factory(:enrollment)
		e2 = Factory(:enrollment)
		subjects = Subject.search(
			:projects => {e1.project.id => ''})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end 

	test "should include subject by multiple projects" do
		e1 = Factory(:enrollment)
		e2 = Factory(:enrollment,:subject => e1.subject)
		e3 = Factory(:enrollment,:project => e2.project)
		subjects = Subject.search(:projects => {
			e1.project.id => '', 
			e2.project.id => ''
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e3.subject)
	end

	test "should include subject by project indifferent completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => YNDK[:no])
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :completed => [true,false] }
		})
		assert subjects.include?(e1.subject)
		assert subjects.include?(e2.subject)
	end

	test "should include subject by project not completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => YNDK[:no])
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :completed => false }
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is completed" do
		e1 = Factory(:enrollment, :completed_on => nil,
			:is_complete => YNDK[:no])
		e2 = Factory(:enrollment, :completed_on => Time.now,
			:is_complete => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :completed => true }
		})
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project indifferent closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :closed => [true,false] }
		})
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :closed => false }
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is closed" do
		e1 = Factory(:enrollment, :is_closed => false)
		e2 = Factory(:enrollment, :is_closed => true,
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :closed => true }
		})
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project indifferent terminated" do
		e1 = Factory(:enrollment, :terminated_participation => YNDK[:no])
		e2 = Factory(:enrollment, :terminated_participation => YNDK[:yes],
			:terminated_reason => 'unknown',
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :terminated => [true,false] }
		})
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not terminated" do
		e1 = Factory(:enrollment, :terminated_participation => YNDK[:no])
		e2 = Factory(:enrollment, :terminated_participation => YNDK[:yes],
			:terminated_reason => 'unknown',
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :terminated => false }
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is terminated" do
		e1 = Factory(:enrollment, :terminated_participation => YNDK[:no])
		e2 = Factory(:enrollment, :terminated_participation => YNDK[:yes],
			:terminated_reason => 'unknown',
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :terminated => true }
		})
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project indifferent consented" do
		e1 = Factory(:enrollment, :consented => YNDK[:no],
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:enrollment, :consented => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :consented => [true,false] }
		})
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not consented" do
		e1 = Factory(:enrollment, :consented => YNDK[:no],
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:enrollment, :consented => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :consented => YNDK[:no] }
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is consented" do
		e1 = Factory(:enrollment, :consented => YNDK[:no],
			:refusal_reason_id => RefusalReason.first.id)
		e2 = Factory(:enrollment, :consented => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :consented => true }
		})
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project indifferent candidate" do
		e1 = Factory(:enrollment, :is_candidate => YNDK[:no])
		e2 = Factory(:enrollment, :is_candidate => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :candidate => [true,false] }
		})
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not candidate" do
		e1 = Factory(:enrollment, :is_candidate => YNDK[:no])
		e2 = Factory(:enrollment, :is_candidate => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :candidate => false }
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is candidate" do
		e1 = Factory(:enrollment, :is_candidate => YNDK[:no])
		e2 = Factory(:enrollment, :is_candidate => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :candidate => true }
		})
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project indifferent chosen" do
		e1 = Factory(:enrollment, :is_chosen => YNDK[:no],
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :chosen => [true,false] }
		})
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not chosen" do
		e1 = Factory(:enrollment, :is_chosen => YNDK[:no],
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :chosen => false }
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is chosen" do
		e1 = Factory(:enrollment, :is_chosen => YNDK[:no],
			:reason_not_chosen => 'unknown')
		e2 = Factory(:enrollment, :is_chosen => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :chosen => true }
		})
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project indifferent eligible" do
		e1 = Factory(:enrollment, :is_eligible => YNDK[:no],
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :eligible => [true,false] }
		})
		assert  subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should include subject by project not eligible" do
		e1 = Factory(:enrollment, :is_eligible => YNDK[:no],
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :eligible => false }
		})
		assert  subjects.include?(e1.subject)
		assert !subjects.include?(e2.subject)
	end

	test "should include subject by project is eligible" do
		e1 = Factory(:enrollment, :is_eligible => YNDK[:no],
			:ineligible_reason_id => IneligibleReason.first.id)
		e2 = Factory(:enrollment, :is_eligible => YNDK[:yes],
			:project => e1.project )
		subjects = Subject.search(:projects => {
			e1.project.id => { :eligible => true }
		})
		assert !subjects.include?(e1.subject)
		assert  subjects.include?(e2.subject)
	end

	test "should NOT order by bogus column with dir" do
		s1,s2,s3 = create_subjects(3)
		subjects = Subject.search(
			:order => 'whatever', :dir => 'asc')
		assert_equal [s1,s2,s3], subjects
	end

	test "should NOT order by bogus column" do
		s1,s2,s3 = create_subjects(3)
		subjects = Subject.search(:order => 'whatever')
		assert_equal [s1,s2,s3], subjects
	end

	test "should order by priority asc by default" do
		project,s1,s2,s3 = create_subjects_with_recruitment_priorities(9,3,6)
		subjects = Subject.search(:order => 'priority',
			:projects=>{ project.id => {} })
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by priority asc" do
		project,s1,s2,s3 = create_subjects_with_recruitment_priorities(9,3,6)
		subjects = Subject.search(:order => 'priority',
			:dir => 'asc',
			:projects=>{ project.id => {} })
		assert_equal [s2,s3,s1], subjects
	end

	test "should order by priority desc" do
		project,s1,s2,s3 = create_subjects_with_recruitment_priorities(9,3,6)
		subjects = Subject.search(:order => 'priority',:dir => 'desc',
			:projects=>{ project.id => {} })
		assert_equal [s1,s3,s2], subjects
	end

	test "should order by id asc by default" do
		s1,s2,s3 = create_subjects_with_childids(9,3,6)
		subjects = Subject.search(
			:order => 'id')
		assert_equal [s1,s2,s3], subjects
	end

	test "should order by id asc" do
		s1,s2,s3 = create_subjects_with_childids(9,3,6)
		subjects = Subject.search(
			:order => 'id', :dir => 'asc')
		assert_equal [s1,s2,s3], subjects
	end

	test "should order by id desc" do
		s1,s2,s3 = create_subjects_with_childids(9,3,6)
		subjects = Subject.search(
			:order => 'id', :dir => 'desc')
		assert_equal [s3,s2,s1], subjects
	end

#			sample_sent_on sample_received_on 
	%w( childid studyid dob first_name last_name 
			sample_outcome interview_outcome_on 
			).each do |column|
		test "should order by #{column} asc by default" do
			s1,s2,s3 = send("three_subjects_with_#{column}")
			subjects = Subject.search(:order => column)
			assert_equal [s2,s3,s1], subjects
		end

		test "should order by #{column} asc" do
			s1,s2,s3 = send("three_subjects_with_#{column}")
			subjects = Subject.search(:order => column, :dir => 'asc')
			assert_equal [s2,s3,s1], subjects
		end

		test "should order by #{column} desc" do
			s1,s2,s3 = send("three_subjects_with_#{column}")
			subjects = Subject.search(:order => column, :dir => 'desc')
			assert_equal [s1,s3,s2], subjects
		end
	end

#	#	There was a problem doing finds which included joins
#	#	which included both sql join fragment strings and an order.
#	test "should work with both dust_kit string and order" do
#		subject1 = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject1.id)
#		subject2 = create_subject
#		subjects = Subject.search(:dust_kit => 'none', 
#			:order => 'childid')
#		assert  subjects.include?(subject2)
#		assert !subjects.include?(subject1)
#	end

	test "should include subject by q first_name" do
		s1,s2 = create_subjects_with_first_names('Michael','Bob')
		subjects = Subject.search(:q => 'mi ch ha')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subject by q last_name" do
		s1,s2 = create_subjects_with_last_names('Michael','Bob')
		subjects = Subject.search(:q => 'cha ael')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subject by q childid" do
		s1,s2 = create_subjects_with_childids(999999,'1')
		subjects = Subject.search(:q => s1.identifier.childid)
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subject by q patid" do
		s1,s2 = create_subjects_with_patids(999999,'1')
		subjects = Subject.search(:q => s1.identifier.patid)
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

	test "should include subject by q gift_card" do
		s1,s2 = create_subjects_with_gift_card_numbers('9999','1111')
		subjects = Subject.search(:q => s1.gift_cards.first.number,
			:search_gift_cards => true)
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
	end

#	test "should return dust_kit_status of None" do
#		subject = create_subject
#		assert_equal 'None', subject.dust_kit_status
#	end

#	test "should return dust_kit_status of New" do
#		subject = create_subject
#		dust_kit = create_dust_kit(:study_subject_id => subject.id)
#		assert_equal 'New', subject.dust_kit_status
#	end

	test "should include subjects with complete sample" do
		s1 = create_hx_subject
		s1.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Complete'])
		s2 = create_subject
		s2.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Pending'])
		s3 = create_subject
		subjects = Subject.search(:sample_outcome => 'Complete')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subjects with incomplete sample" do
		s1 = create_hx_subject
		s1.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Complete'])
		s2 = create_subject
		s2.create_homex_outcome(
			:sample_outcome_on => Date.today,
			:sample_outcome => SampleOutcome['Pending'])
		s3 = create_subject
		subjects = Subject.search(:sample_outcome => 'Incomplete')
		assert !subjects.include?(s1)
		assert  subjects.include?(s2)
		assert  subjects.include?(s3)
	end

	test "should include subjects with complete interview" do
		s1 = create_hx_subject
		s1.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Complete'])
		s2 = create_subject
		s2.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Incomplete'])
		s3 = create_subject
		subjects = Subject.search(:interview_outcome => 'Complete')
		assert  subjects.include?(s1)
		assert !subjects.include?(s2)
		assert !subjects.include?(s3)
	end

	test "should include subjects with incomplete interview" do
		s1 = create_hx_subject
		s1.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Complete'])
		s2 = create_subject
		s2.create_homex_outcome(
			:interview_outcome_on => Date.today,
			:interview_outcome => InterviewOutcome['Incomplete'])
		s3 = create_subject
		subjects = Subject.search(:interview_outcome => 'Incomplete')
		assert !subjects.include?(s1)
		assert  subjects.include?(s2)
		assert  subjects.include?(s3)
	end

protected

	def create_survey_response_sets
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey,
			:subject => rs1.subject)
		[rs1.reload,rs2.reload]
	end

end
