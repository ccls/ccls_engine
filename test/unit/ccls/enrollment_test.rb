require 'test_helper'

class Ccls::EnrollmentTest < ActiveSupport::TestCase

	[ :use_smp_future_rsrch,
		:use_smp_future_cancer_rsrch, :use_smp_future_other_rsrch,
		:share_smp_with_others, :contact_for_related_study,
		:provide_saliva_smp, :receive_study_findings ].each do |field|

		#	Making assumption that 12345 will NEVER be a valid value.
		test "should NOT allow 12345 for #{field}" do
			enrollment = Enrollment.new(field => 12345)
			enrollment.valid?
			assert enrollment.errors.on_attr_and_type?(field,:inclusion)
		end

		test "should allow nil for #{field}" do
			enrollment = Enrollment.new(field => nil)
			assert_nil enrollment.send(field)
			enrollment.valid?
			assert !enrollment.errors.on(field)
		end

		test "should allow all valid ADNA values for #{field}" do
			enrollment = Enrollment.new
			ADNA.valid_values.each do |value|
				enrollment.send("#{field}=", value)
				enrollment.valid?
				assert !enrollment.errors.on(field)
			end
		end

	end

	[ :consented, :is_eligible,
		:is_chosen, :is_complete, :terminated_participation,
		:is_candidate ].each do |field|

		#	Making assumption that 12345 will NEVER be a valid value.
		test "should NOT allow 12345 for #{field}" do
			enrollment = Enrollment.new(field => 12345)
			enrollment.valid?
			assert enrollment.errors.on_attr_and_type?(field,:inclusion)
		end

		test "should allow nil for #{field}" do
			enrollment = Enrollment.new(field => nil)
			assert_nil enrollment.send(field)
			enrollment.valid?
			assert !enrollment.errors.on(field)
		end

		test "should allow all valid YNDK values for #{field}" do
			enrollment = Enrollment.new
			YNDK.valid_values.each do |value|
				enrollment.send("#{field}=", value)
				enrollment.valid?
				assert !enrollment.errors.on(field)
			end
		end

	end



	assert_should_create_default_object
	assert_should_protect(:study_subject_id, :study_subject)
	assert_should_not_require_attributes( 
		:refused_by_physician,
		:refused_by_family,
		:use_smp_future_rsrch,
		:use_smp_future_cancer_rsrch,
		:use_smp_future_other_rsrch,
		:share_smp_with_others,
		:contact_for_related_study,
		:provide_saliva_smp,
		:receive_study_findings,
		:position,
		:recruitment_priority,
#		:able_to_locate,
		:is_candidate,
		:is_eligible,
		:ineligible_reason_id,
		:ineligible_reason_specify,
		:refusal_reason_id,
		:other_refusal_reason,
		:is_chosen,
		:reason_not_chosen,
		:terminated_participation,
		:terminated_reason,
		:is_complete,
		:completed_on,
		:is_closed,
		:reason_closed,
		:notes,
		:document_version_id )
	assert_should_require_attribute_length( 
		:recruitment_priority,
		:ineligible_reason_specify,
		:other_refusal_reason,
		:reason_not_chosen,
		:terminated_reason,
		:reason_closed, 
			:maximum => 250 )

	assert_should_have_many(:follow_ups)
	assert_should_have_many(:operational_events)
	assert_should_belong_to( 
		:tracing_status,
		:project_outcome,
		:ineligible_reason,
		:refusal_reason,
		:document_version )
	assert_should_require_attribute_length( :notes, :maximum => 65000 )

#	using subjectless_enrollment so, this isn't true
#	assert_should_initially_belong_to(:study_subject, :project)
	assert_should_belong_to(:study_subject)

	assert_should_initially_belong_to(:project)
	assert_requires_complete_date(:completed_on, :consented_on)
	assert_requires_past_date(    :completed_on, :consented_on)

	test "explicit Factory enrollment test" do
		assert_difference('Project.count',1) {
		assert_difference('StudySubject.count',1) {
		assert_difference('Enrollment.count',2) {	#	this enrollment AND the subject's ccls enrollment
			enrollment = Factory(:enrollment)
			assert !enrollment.consented
			assert_not_nil enrollment.project
			assert_not_nil enrollment.study_subject
		} } }
	end

	test "explicit Factory subjectless_enrollment test" do
		assert_difference('Project.count',1) {
		assert_difference('StudySubject.count',0) {
		assert_difference('Enrollment.count',1) {
			enrollment = Factory(:subjectless_enrollment)
			assert !enrollment.consented
			assert_not_nil enrollment.project
			assert_nil     enrollment.study_subject
		} } }
	end

	test "explicit Factory consented_enrollment test" do
		assert_difference('Project.count',1) {
		assert_difference('StudySubject.count',1) {
		assert_difference('Enrollment.count',2) {	#	this enrollment AND the subject's ccls enrollment
			enrollment = Factory(:consented_enrollment)
			assert enrollment.consented
			assert_equal enrollment.consented, YNDK[:yes]
			assert_not_nil enrollment.project
			assert_not_nil enrollment.study_subject
		} } }
	end

	test "explicit Factory declined_enrollment test" do
		assert_difference('Project.count',1) {
		assert_difference('StudySubject.count',1) {
		assert_difference('Enrollment.count',2) {	#	this enrollment AND the subject's ccls enrollment
			enrollment = Factory(:declined_enrollment)
			assert enrollment.consented
			assert_equal enrollment.consented, YNDK[:no]
			assert_not_nil enrollment.project
			assert_not_nil enrollment.study_subject
		} } }
	end

	test "should require project" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment( :project => nil)
			assert !enrollment.errors.on(:project)
			assert  enrollment.errors.on_attr_and_type?(:project_id,:blank)
		end
	end

	test "should require valid project" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment( :project_id => 0)
			assert !enrollment.errors.on(:project_id)
			assert  enrollment.errors.on_attr_and_type?(:project,:blank)
		end
	end

	test "should require unique project_id scope study_subject_id" do
		o = create_enrollment
		assert_no_difference "Enrollment.count" do
			enrollment = create_enrollment(:project => o.project,
				:study_subject => o.study_subject)
			assert enrollment.errors.on_attr_and_type?(:project_id, :taken)
		end
	end

#	test "should require completed_on be in the past" do
#		assert_difference( "Enrollment.count", 0 ) do
#			enrollment = create_enrollment(
#				:is_complete  => YNDK[:yes],
#				:completed_on => Date.tomorrow )
#			#	sometimes this fails during test:coverage?
#			assert enrollment.errors.on(:completed_on)
#			assert_match(/future/,
#				enrollment.errors.on(:completed_on))
#		end
#	end

	test "should require ineligible_reason if is_eligible == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:is_eligible => YNDK[:no])
			assert !enrollment.errors.on(:ineligible_reason)
			assert  enrollment.errors.on_attr_and_type?(:ineligible_reason_id,:blank)
		end
	end
	test "should require valid ineligible_reason if is_eligible == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:is_eligible => YNDK[:no],
				:ineligible_reason_id => 0)
			assert !enrollment.errors.on(:ineligible_reason_id)
			assert  enrollment.errors.on_attr_and_type?(:ineligible_reason,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW ineligible_reason if is_eligible == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:is_eligible => YNDK[yndk],
					:ineligible_reason => Factory(:ineligible_reason) )
				assert !enrollment.errors.on(:ineligible_reason)
				assert  enrollment.errors.on_attr_and_type?(:ineligible_reason_id,:present)
			end
		end
	end

	test "should require ineligible_reason_specify if " <<
			"ineligible_reason == other" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(
				:is_eligible => YNDK[:no],
				:ineligible_reason => IneligibleReason['other'] )
			assert enrollment.errors.on(:ineligible_reason_specify)
			assert enrollment.errors.on_attr_and_type?(:ineligible_reason_specify,:blank)
		end
	end
	test "should ALLOW ineligible_reason_specify if " <<
			"ineligible_reason != other" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_subjectless_enrollment(
				:is_eligible => YNDK[:no],
				:ineligible_reason => Factory(:ineligible_reason),
				:ineligible_reason_specify => 'blah blah blah' )
			assert !enrollment.errors.on(:ineligible_reason_specify)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW ineligible_reason_specify if " <<
				"is_eligible == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(
					:is_eligible => YNDK[yndk],
					:ineligible_reason => Factory(:ineligible_reason),
					:ineligible_reason_specify => 'blah blah blah' )
				assert enrollment.errors.on(:ineligible_reason_specify)
				assert enrollment.errors.on_attr_and_type?(:ineligible_reason_specify,:present)
			end
		end
	end


	test "should require reason_not_chosen if is_chosen == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:is_chosen => YNDK[:no])
			assert enrollment.errors.on(:reason_not_chosen)
			assert enrollment.errors.on_attr_and_type?(:reason_not_chosen,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW reason_not_chosen if is_chosen == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:is_chosen => YNDK[yndk],
					:reason_not_chosen => "blah blah blah")
				assert enrollment.errors.on(:reason_not_chosen)
				assert enrollment.errors.on_attr_and_type?(:reason_not_chosen,:present)
			end
		end
	end


	test "should require refusal_reason if consented == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:consented => YNDK[:no])
			assert !enrollment.errors.on(:refusal_reason)
			assert  enrollment.errors.on_attr_and_type?(:refusal_reason_id,:blank)
		end
	end
	test "should require valid refusal_reason if consented == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:consented => YNDK[:no],
				:refusal_reason_id => 0)
			assert !enrollment.errors.on(:refusal_reason_id)
			assert  enrollment.errors.on_attr_and_type?(:refusal_reason,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW refusal_reason if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:consented => YNDK[yndk],
					:refusal_reason => Factory(:refusal_reason))
				assert !enrollment.errors.on(:refusal_reason)
				assert  enrollment.errors.on_attr_and_type?(:refusal_reason_id,:present)
			end
		end
	end

	test "should require other_refusal_reason if " <<
			"refusal_reason == other" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:consented => YNDK[:no],
				:refusal_reason => RefusalReason['other'] )
			assert enrollment.errors.on(:other_refusal_reason)
			assert enrollment.errors.on_attr_and_type?(:other_refusal_reason,:blank)
		end
	end
	test "should ALLOW other_refusal_reason if " <<
			"refusal_reason != other" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_subjectless_enrollment(:consented => YNDK[:no],
				:consented_on => Date.today,
				:refusal_reason => Factory(:refusal_reason),
				:other_refusal_reason => 'asdfasdf' )
			assert !enrollment.errors.on(:other_refusal_reason)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW other_refusal_reason if "<<
				"consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:consented => YNDK[yndk],
					:refusal_reason => Factory(:refusal_reason),
					:other_refusal_reason => 'asdfasdf' )
				assert enrollment.errors.on(:other_refusal_reason)
				assert enrollment.errors.on_attr_and_type?(:other_refusal_reason,:present)
			end
		end
	end


	[:yes,:no].each do |yndk|
		test "should require consented_on if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:consented => YNDK[yndk],
					:consented_on => nil)
				assert enrollment.errors.on_attr_and_type?(:consented_on,:blank)
			end
		end
	end
	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW consented_on if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:consented => YNDK[yndk],
					:consented_on => Date.today)
				assert enrollment.errors.on(:consented_on)
				assert enrollment.errors.on_attr_and_type?(:consented_on,:present)
			end
		end
	end


	test "should require terminated_reason if " <<
			"terminated_participation == :yes" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:terminated_participation => YNDK[:yes])
			assert enrollment.errors.on(:terminated_reason)
			assert enrollment.errors.on_attr_and_type?(:terminated_reason,:blank)
		end
	end
	[:no,:dk,:nil].each do |yndk|
		test "should NOT ALLOW terminated_reason if " <<
				"terminated_participation == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(
					:terminated_participation => YNDK[yndk],
					:terminated_reason => 'some bogus reason')
				assert enrollment.errors.on(:terminated_reason)
				assert enrollment.errors.on_attr_and_type?(:terminated_reason,:present)
			end
		end
	end


	test "should require completed_on if is_complete == :yes" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:is_complete => YNDK[:yes])
			assert enrollment.errors.on(:completed_on)
			assert enrollment.errors.on_attr_and_type?(:completed_on,:blank)
		end
	end
	[:no,:dk,:nil].each do |yndk|
		test "should NOT ALLOW completed_on if is_complete == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:is_complete => YNDK[yndk],
					:completed_on => Date.today)
				assert enrollment.errors.on(:completed_on)
				assert enrollment.errors.on_attr_and_type?(:completed_on,:present)
			end
		end
	end


	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW document_version_id if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_subjectless_enrollment(:consented => YNDK[yndk],
					:document_version => Factory(:document_version) )
				assert !enrollment.errors.on(:document_version)
				assert  enrollment.errors.on_attr_and_type?(:document_version_id,:present)
			end
		end
	end
	test "should allow document_version_id if consented == :yes" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_subjectless_enrollment(:consented => YNDK[:yes],
				:consented_on     => Date.today,
				:document_version => Factory(:document_version) )
		end
	end
	test "should allow document_version_id if consented == :no" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_subjectless_enrollment(:consented => YNDK[:no],
				:consented_on     => Date.today,
				:refusal_reason   => Factory(:refusal_reason),
				:document_version => Factory(:document_version) )
		end
	end
	test "should require valid document_version if given" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_subjectless_enrollment(:consented => YNDK[:yes],
				:consented_on     => Date.today,
				:document_version_id => 0 )
			assert !enrollment.errors.on(:document_version_id)
			assert  enrollment.errors.on_attr_and_type?(:document_version,:blank)
		end
	end


	test "should create operational event when enrollment complete" do
		enrollment = create_subjectless_enrollment(
			:completed_on => nil,
			:is_complete => YNDK[:no])
		#	arbitrary past date
		past_date = Date.parse('Jan 15 2003')
		assert_difference('OperationalEvent.count',1) do
			enrollment.update_attributes(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		oe = enrollment.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'complete', oe.operational_event_type.key
		assert_equal past_date,  oe.occurred_on
		assert_equal enrollment.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create operational event when enrollment complete UNSET" do
		#	arbitrary past date
		past_date = Date.parse('Jan 15 2003')
		enrollment = nil
		assert_difference('OperationalEvent.count',1) do
			enrollment = create_subjectless_enrollment(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		oe = enrollment.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'complete', oe.operational_event_type.key
		assert_difference('OperationalEvent.count',1) do
			enrollment.update_attributes(
				:is_complete => YNDK[:no],
				:completed_on => nil)
		end
		oe = enrollment.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'reopened', oe.operational_event_type.key
		assert_equal Date.today, oe.occurred_on
		assert_equal enrollment.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create subjectConsents operational event if consent changes to yes" do
		enrollment = Factory(:subjectless_enrollment)
		assert_nil enrollment.consented
		assert_difference("Enrollment.find(#{enrollment.id}).operational_events.count",1){
			enrollment.update_attributes(:consented => YNDK[:yes],
				:consented_on => Date.today )
		}
		enrollment.reload
		assert_equal enrollment.consented, YNDK[:yes]
		assert_equal enrollment.consented_on, Date.today
		consented_event = enrollment.operational_events.find(:first,:conditions => {
			:operational_event_type_id => OperationalEventType['subjectConsents'].id })
		assert_not_nil consented_event
	end

	test "should not create subjectConsents operational event if consent doesn't change" do
		enrollment = Factory(:consented_enrollment)
		assert_not_nil enrollment.consented
		assert_difference("Enrollment.find(#{enrollment.id}).operational_events.count",0){
			enrollment.update_attributes(:consented => YNDK[:yes],
				:consented_on => Date.today )
		}
		enrollment.reload
		assert_equal enrollment.consented, YNDK[:yes]
		assert_equal enrollment.consented_on, Date.today
		consented_event = enrollment.operational_events.find(:first,:conditions => {
			:operational_event_type_id => OperationalEventType['subjectConsents'].id })
		assert_not_nil consented_event
	end

	test "should create subjectDeclines operational event if consent changes to no" do
		enrollment = Factory(:subjectless_enrollment)
		assert_nil enrollment.consented
		assert_difference("Enrollment.find(#{enrollment.id}).operational_events.count",1){
			enrollment.update_attributes(:consented => YNDK[:no],
				:refusal_reason => Factory(:refusal_reason),
				:consented_on   => Date.today )
		}
		enrollment.reload
		assert_equal enrollment.consented, YNDK[:no]
		assert_equal enrollment.consented_on, Date.today
		declined_event = enrollment.operational_events.find(:first,:conditions => {
			:operational_event_type_id => OperationalEventType['subjectDeclines'].id })
		assert_not_nil declined_event
	end

	test "should not create subjectDeclines operational event if consent doesn't change" do
		enrollment = Factory(:declined_enrollment)
		assert_not_nil enrollment.consented
		assert_difference("Enrollment.find(#{enrollment.id}).operational_events.count",0){
			enrollment.update_attributes(:consented => YNDK[:no],
				:consented_on => Date.today )
		}
		enrollment.reload
		assert_equal enrollment.consented, YNDK[:no]
		assert_equal enrollment.consented_on, Date.today
		declined_event = enrollment.operational_events.find(:first,:conditions => {
			:operational_event_type_id => OperationalEventType['subjectDeclines'].id })
		assert_not_nil declined_event
	end

	test "should have consented named_scope" do
		assert_equal [], Enrollment.consented
		Factory(:enrollment)
		assert_equal [], Enrollment.consented
		enrollment = Factory(:consented_enrollment)
		assert_equal [enrollment], Enrollment.consented
		Factory(:enrollment)
		assert_equal [enrollment], Enrollment.consented
	end

protected

	#	MUST define this method so can use the alias_method below.
	#	Or could just define create_object.  Either way.
	def create_subjectless_enrollment(options={})
		enrollment = Factory.build(:subjectless_enrollment,options)
		enrollment.save
		enrollment
	end

#	create_object is used in the basic assertions,
#	but it creates a subject which creates an enrollment and operational_event
#	so if I create a subjectless enrollment, they work
	alias_method :create_object, :create_subjectless_enrollment

#	def create_enrollment(options={})
#		enrollment = Factory.build(:enrollment,options)
#		enrollment.save
#		enrollment
#	end

end
