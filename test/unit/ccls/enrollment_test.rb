require 'test_helper'

class Ccls::EnrollmentTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_require_unique_attribute(:project_id, :scope => :study_subject_id)
	assert_should_not_require_attributes( :position,
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

	assert_should_have_many(:operational_events)
	assert_should_belong_to( 
		:project_outcome,
		:ineligible_reason,
		:refusal_reason,
		:document_version )
	assert_should_initially_belong_to(:subject, :project)
	assert_requires_complete_date(:completed_on, :consented_on)
	assert_requires_past_date(    :completed_on, :consented_on)

#	test "should require completed_on be in the past" do
#		assert_difference( "#{model_name}.count", 0 ) do
#			object = create_object(
#				:is_complete  => YNDK[:yes],
#				:completed_on => Chronic.parse('tomorrow'))
#			#	sometimes this fails during test:coverage?
#			assert object.errors.on(:completed_on)
#			assert_match(/future/,
#				object.errors.on(:completed_on))
#		end
#	end

	test "should require ineligible_reason if is_eligible == :no" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_eligible => YNDK[:no])
			assert object.errors.on(:ineligible_reason)
			assert object.errors.on_attr_and_type(:ineligible_reason,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW ineligible_reason if is_eligible == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:is_eligible => YNDK[yndk],
					:ineligible_reason => Factory(:ineligible_reason) )
				assert object.errors.on(:ineligible_reason)
				assert object.errors.on_attr_and_type(:ineligible_reason,:present)
			end
		end
	end

	test "should require ineligible_reason_specify if " <<
			"ineligible_reason == other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:is_eligible => YNDK[:no],
				:ineligible_reason => IneligibleReason['other'] )
			assert object.errors.on(:ineligible_reason_specify)
			assert object.errors.on_attr_and_type(:ineligible_reason_specify,:blank)
		end
	end
	test "should ALLOW ineligible_reason_specify if " <<
			"ineligible_reason != other" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(
				:is_eligible => YNDK[:no],
				:ineligible_reason => Factory(:ineligible_reason),
				:ineligible_reason_specify => 'blah blah blah' )
			assert !object.errors.on(:ineligible_reason_specify)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW ineligible_reason_specify if " <<
				"is_eligible == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(
					:is_eligible => YNDK[yndk],
					:ineligible_reason => Factory(:ineligible_reason),
					:ineligible_reason_specify => 'blah blah blah' )
				assert object.errors.on(:ineligible_reason_specify)
				assert object.errors.on_attr_and_type(:ineligible_reason_specify,:present)
			end
		end
	end


	test "should require reason_not_chosen if is_chosen == :no" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_chosen => YNDK[:no])
			assert object.errors.on(:reason_not_chosen)
			assert object.errors.on_attr_and_type(:reason_not_chosen,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW reason_not_chosen if is_chosen == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:is_chosen => YNDK[yndk],
					:reason_not_chosen => "blah blah blah")
				assert object.errors.on(:reason_not_chosen)
				assert object.errors.on_attr_and_type(:reason_not_chosen,:present)
			end
		end
	end


	test "should require refusal_reason if consented == :no" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:consented => YNDK[:no])
			assert object.errors.on(:refusal_reason)
			assert object.errors.on_attr_and_type(:refusal_reason,:blank)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW refusal_reason if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:refusal_reason => Factory(:refusal_reason))
				assert object.errors.on(:refusal_reason)
				assert object.errors.on_attr_and_type(:refusal_reason,:present)
			end
		end
	end

	test "should require other_refusal_reason if " <<
			"refusal_reason == other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:consented => YNDK[:no],
				:refusal_reason => RefusalReason['other'] )
			assert object.errors.on(:other_refusal_reason)
			assert object.errors.on_attr_and_type(:other_refusal_reason,:blank)
		end
	end
	test "should ALLOW other_refusal_reason if " <<
			"refusal_reason != other" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:consented => YNDK[:no],
				:refusal_reason => Factory(:refusal_reason),
				:other_refusal_reason => 'asdfasdf' )
			assert !object.errors.on(:other_refusal_reason)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW other_refusal_reason if "<<
				"consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:refusal_reason => Factory(:refusal_reason),
					:other_refusal_reason => 'asdfasdf' )
				assert object.errors.on(:other_refusal_reason)
				assert object.errors.on_attr_and_type(:other_refusal_reason,:present)
			end
		end
	end


	[:yes,:no].each do |yndk|
		test "should require consented_on if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:consented_on => nil)
				assert object.errors.on_attr_and_type(:consented_on,:blank)
			end
		end
	end
	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW consented_on if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:consented_on => Date.today)
				assert object.errors.on(:consented_on)
				assert object.errors.on_attr_and_type(:consented_on,:present)
			end
		end
	end


	test "should require terminated_reason if " <<
			"terminated_participation == :yes" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:terminated_participation => YNDK[:yes])
			assert object.errors.on(:terminated_reason)
			assert object.errors.on_attr_and_type(:terminated_reason,:blank)
		end
	end

	[:no,:dk,:nil].each do |yndk|
		test "should NOT ALLOW terminated_reason if " <<
				"terminated_participation == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(
					:terminated_participation => YNDK[yndk],
					:terminated_reason => 'some bogus reason')
				assert object.errors.on(:terminated_reason)
				assert object.errors.on_attr_and_type(:terminated_reason,:present)
			end
		end
	end


	test "should require completed_on if is_complete == :yes" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_complete => YNDK[:yes])
			assert object.errors.on(:completed_on)
			assert object.errors.on_attr_and_type(:completed_on,:blank)
		end
	end
	[:no,:dk,:nil].each do |yndk|
		test "should NOT ALLOW completed_on if is_complete == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:is_complete => YNDK[yndk],
					:completed_on => Date.today)
				assert object.errors.on(:completed_on)
				assert object.errors.on_attr_and_type(:completed_on,:present)
			end
		end
	end


	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW document_version_id if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:document_version => Factory(:document_version) )
				assert object.errors.on(:document_version)
				assert object.errors.on_attr_and_type(:document_version,:present)
			end
		end
	end

	test "should allow document_version_id if consented == :yes" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:consented => YNDK[:yes],
				:document_version => Factory(:document_version) )
		end
	end

	test "should allow document_version_id if consented == :no" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:consented => YNDK[:no],
				:refusal_reason   => Factory(:refusal_reason),
				:document_version => Factory(:document_version) )
		end
	end



	test "should create operational event when enrollment complete" do
		object = create_object(
			:completed_on => nil,
			:is_complete => YNDK[:no])
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		oe = object.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'complete', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal object.study_subject_id, oe.enrollment.study_subject_id
	end

	test "should create operational event when enrollment complete UNSET" do
		past_date = Chronic.parse('Jan 15 2003').to_date
		object = nil
		assert_difference('OperationalEvent.count',1) do
			object = create_object(
				:completed_on => past_date,
				:is_complete => YNDK[:yes])
		end
		oe = object.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'complete', oe.operational_event_type.code
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:is_complete => YNDK[:no],
				:completed_on => nil)
		end
		oe = object.operational_events.find(:last,:order => 'id ASC')
		assert_equal 'reopened', oe.operational_event_type.code
		assert_equal Date.today, oe.occurred_on
		assert_equal object.study_subject_id, oe.enrollment.study_subject_id
	end

end
