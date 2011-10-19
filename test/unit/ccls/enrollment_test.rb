require 'test_helper'

class Ccls::EnrollmentTest < ActiveSupport::TestCase

	assert_should_create_default_object

#	TODO doesn't actually generate an error any more in the factory
#	i think that it is the non-standard name
#	assert_should_require_unique_attribute(:project_id, :scope => :study_subject_id)

	test "should require unique project_id scope study_subject_id" do
		o = create_enrollment
		assert_no_difference "Enrollment.count" do
			enrollment = create_enrollment(:project => o.project,:study_subject => o.study_subject)
			assert enrollment.errors.on_attr_and_type(:project_id, :taken)
		end
	end

	assert_should_not_require_attributes( 
		:position,
		:recruitment_priority,
		:able_to_locate,
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
		:project_outcome,
		:ineligible_reason,
		:refusal_reason,
		:document_version )
	assert_should_initially_belong_to(:study_subject, :project)
	assert_requires_complete_date(:completed_on, :consented_on)
	assert_requires_past_date(    :completed_on, :consented_on)

#	test "should require completed_on be in the past" do
#		assert_difference( "Enrollment.count", 0 ) do
#			enrollment = create_enrollment(
#				:is_complete  => YNDK[:yes],
#				:completed_on => Chronic.parse('tomorrow'))
#			#	sometimes this fails during test:coverage?
#			assert enrollment.errors.on(:completed_on)
#			assert_match(/future/,
#				enrollment.errors.on(:completed_on))
#		end
#	end

	test "should require ineligible_reason if is_eligible == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_enrollment(:is_eligible => YNDK[:no])
			assert enrollment.errors.on(:ineligible_reason)
			assert enrollment.errors.on_attr_and_type(:ineligible_reason,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW ineligible_reason if is_eligible == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:is_eligible => YNDK[yndk],
					:ineligible_reason => Factory(:ineligible_reason) )
				assert enrollment.errors.on(:ineligible_reason)
				assert enrollment.errors.on_attr_and_type(:ineligible_reason,:present)
			end
		end
	end

	test "should require ineligible_reason_specify if " <<
			"ineligible_reason == other" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_enrollment(
				:is_eligible => YNDK[:no],
				:ineligible_reason => IneligibleReason['other'] )
			assert enrollment.errors.on(:ineligible_reason_specify)
			assert enrollment.errors.on_attr_and_type(:ineligible_reason_specify,:blank)
		end
	end
	test "should ALLOW ineligible_reason_specify if " <<
			"ineligible_reason != other" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_enrollment(
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
				enrollment = create_enrollment(
					:is_eligible => YNDK[yndk],
					:ineligible_reason => Factory(:ineligible_reason),
					:ineligible_reason_specify => 'blah blah blah' )
				assert enrollment.errors.on(:ineligible_reason_specify)
				assert enrollment.errors.on_attr_and_type(:ineligible_reason_specify,:present)
			end
		end
	end


	test "should require reason_not_chosen if is_chosen == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_enrollment(:is_chosen => YNDK[:no])
			assert enrollment.errors.on(:reason_not_chosen)
			assert enrollment.errors.on_attr_and_type(:reason_not_chosen,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW reason_not_chosen if is_chosen == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:is_chosen => YNDK[yndk],
					:reason_not_chosen => "blah blah blah")
				assert enrollment.errors.on(:reason_not_chosen)
				assert enrollment.errors.on_attr_and_type(:reason_not_chosen,:present)
			end
		end
	end


	test "should require refusal_reason if consented == :no" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_enrollment(:consented => YNDK[:no])
			assert enrollment.errors.on(:refusal_reason)
			assert enrollment.errors.on_attr_and_type(:refusal_reason,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW refusal_reason if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:consented => YNDK[yndk],
					:refusal_reason => Factory(:refusal_reason))
				assert enrollment.errors.on(:refusal_reason)
				assert enrollment.errors.on_attr_and_type(:refusal_reason,:present)
			end
		end
	end

	test "should require other_refusal_reason if " <<
			"refusal_reason == other" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_enrollment(:consented => YNDK[:no],
				:refusal_reason => RefusalReason['other'] )
			assert enrollment.errors.on(:other_refusal_reason)
			assert enrollment.errors.on_attr_and_type(:other_refusal_reason,:blank)
		end
	end
	test "should ALLOW other_refusal_reason if " <<
			"refusal_reason != other" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_enrollment(:consented => YNDK[:no],
				:refusal_reason => Factory(:refusal_reason),
				:other_refusal_reason => 'asdfasdf' )
			assert !enrollment.errors.on(:other_refusal_reason)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW other_refusal_reason if "<<
				"consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:consented => YNDK[yndk],
					:refusal_reason => Factory(:refusal_reason),
					:other_refusal_reason => 'asdfasdf' )
				assert enrollment.errors.on(:other_refusal_reason)
				assert enrollment.errors.on_attr_and_type(:other_refusal_reason,:present)
			end
		end
	end


	[:yes,:no].each do |yndk|
		test "should require consented_on if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:consented => YNDK[yndk],
					:consented_on => nil)
				assert enrollment.errors.on_attr_and_type(:consented_on,:blank)
			end
		end
	end
	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW consented_on if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:consented => YNDK[yndk],
					:consented_on => Date.today)
				assert enrollment.errors.on(:consented_on)
				assert enrollment.errors.on_attr_and_type(:consented_on,:present)
			end
		end
	end


	test "should require terminated_reason if " <<
			"terminated_participation == :yes" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_enrollment(:terminated_participation => YNDK[:yes])
			assert enrollment.errors.on(:terminated_reason)
			assert enrollment.errors.on_attr_and_type(:terminated_reason,:blank)
		end
	end

	[:no,:dk,:nil].each do |yndk|
		test "should NOT ALLOW terminated_reason if " <<
				"terminated_participation == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(
					:terminated_participation => YNDK[yndk],
					:terminated_reason => 'some bogus reason')
				assert enrollment.errors.on(:terminated_reason)
				assert enrollment.errors.on_attr_and_type(:terminated_reason,:present)
			end
		end
	end


	test "should require completed_on if is_complete == :yes" do
		assert_difference( "Enrollment.count", 0 ) do
			enrollment = create_enrollment(:is_complete => YNDK[:yes])
			assert enrollment.errors.on(:completed_on)
			assert enrollment.errors.on_attr_and_type(:completed_on,:blank)
		end
	end
	[:no,:dk,:nil].each do |yndk|
		test "should NOT ALLOW completed_on if is_complete == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:is_complete => YNDK[yndk],
					:completed_on => Date.today)
				assert enrollment.errors.on(:completed_on)
				assert enrollment.errors.on_attr_and_type(:completed_on,:present)
			end
		end
	end


	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW document_version_id if consented == #{yndk}" do
			assert_difference( "Enrollment.count", 0 ) do
				enrollment = create_enrollment(:consented => YNDK[yndk],
					:document_version => Factory(:document_version) )
				assert enrollment.errors.on(:document_version)
				assert enrollment.errors.on_attr_and_type(:document_version,:present)
			end
		end
	end

	test "should allow document_version_id if consented == :yes" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_enrollment(:consented => YNDK[:yes],
				:document_version => Factory(:document_version) )
		end
	end

	test "should allow document_version_id if consented == :no" do
		assert_difference( "Enrollment.count", 1 ) do
			enrollment = create_enrollment(:consented => YNDK[:no],
				:refusal_reason   => Factory(:refusal_reason),
				:document_version => Factory(:document_version) )
		end
	end



	test "should create operational event when enrollment complete" do
		enrollment = create_enrollment(
			:completed_on => nil,
			:is_complete => YNDK[:no])
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			enrollment.update_attributes(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		oe = enrollment.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'complete', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal enrollment.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create operational event when enrollment complete UNSET" do
		past_date = Chronic.parse('Jan 15 2003').to_date
		enrollment = nil
		assert_difference('OperationalEvent.count',1) do
			enrollment = create_enrollment(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		oe = enrollment.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'complete', oe.operational_event_type.code
		assert_difference('OperationalEvent.count',1) do
			enrollment.update_attributes(
				:is_complete => YNDK[:no],
				:completed_on => nil)
		end
		oe = enrollment.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'reopened', oe.operational_event_type.code
		assert_equal Date.today, oe.occurred_on
		assert_equal enrollment.study_subject_id, oe.enrollment.study_subject_id
	end

protected

	def create_enrollment(options={})
		enrollment = Factory.build(:enrollment,options)
		enrollment.save
		enrollment
	end

end
