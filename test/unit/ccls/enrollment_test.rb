require File.dirname(__FILE__) + '/../test_helper'

class EnrollmentTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_require_unique_attribute(:project_id, :scope => :study_subject_id)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :recruitment_priority )
	assert_should_not_require_attributes( :able_to_locate )
	assert_should_not_require_attributes( :is_candidate )
	assert_should_not_require_attributes( :is_eligible )
	assert_should_not_require_attributes( :ineligible_reason_id )
	assert_should_not_require_attributes( :ineligible_reason_specify )
	assert_should_not_require_attributes( :refusal_reason_id )
	assert_should_not_require_attributes( :other_refusal_reason )
	assert_should_not_require_attributes( :is_chosen )
	assert_should_not_require_attributes( :reason_not_chosen )
	assert_should_not_require_attributes( :terminated_participation )
	assert_should_not_require_attributes( :terminated_reason )
	assert_should_not_require_attributes( :is_complete )
	assert_should_not_require_attributes( :completed_on )
	assert_should_not_require_attributes( :is_closed )
	assert_should_not_require_attributes( :reason_closed )
	assert_should_not_require_attributes( :notes )
	assert_should_not_require_attributes( :document_version_id )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :recruitment_priority )
		o.assert_should_require_attribute_length( :ineligible_reason_specify )
		o.assert_should_require_attribute_length( :other_refusal_reason )
		o.assert_should_require_attribute_length( :reason_not_chosen )
		o.assert_should_require_attribute_length( :terminated_reason )
		o.assert_should_require_attribute_length( :reason_closed )
	end

	assert_should_have_many(:operational_events)
	assert_should_belong_to( :project_outcome )
	assert_should_belong_to( :ineligible_reason )
	assert_should_belong_to( :refusal_reason )
	assert_should_belong_to( :document_version )
	assert_should_initially_belong_to(:subject)
	assert_should_initially_belong_to(:project)
	assert_requires_complete_date(:completed_on)
	assert_requires_complete_date(:consented_on)

	test "should require consented_on be in the past" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:consented_on => Chronic.parse('tomorrow'))
			assert object.errors.on(:consented_on)
			assert_match(/future/,
				object.errors.on(:consented_on))
		end
	end

	test "should require completed_on be in the past" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:is_complete  => YNDK[:yes],
				:completed_on => Chronic.parse('tomorrow'))
			#	sometimes this fails during test:coverage?
			assert object.errors.on(:completed_on)
			assert_match(/future/,
				object.errors.on(:completed_on))
		end
	end


	test "should require ineligible_reason if is_eligible == :no" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_eligible => YNDK[:no])
			assert object.errors.on(:ineligible_reason)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW ineligible_reason if is_eligible == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:is_eligible => YNDK[yndk],
					:ineligible_reason => Factory(:ineligible_reason) )
				assert object.errors.on(:ineligible_reason)
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
			end
		end
	end


	test "should require reason_not_chosen if is_chosen == :no" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_chosen => YNDK[:no])
			assert object.errors.on(:reason_not_chosen)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW reason_not_chosen if is_chosen == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:is_chosen => YNDK[yndk],
					:reason_not_chosen => "blah blah blah")
				assert object.errors.on(:reason_not_chosen)
			end
		end
	end


	test "should require refusal_reason if consented == :no" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:consented => YNDK[:no])
			assert object.errors.on(:refusal_reason)
		end
	end
	[:yes,:dk,:nil].each do |yndk|
		test "should NOT ALLOW refusal_reason if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:refusal_reason => Factory(:refusal_reason))
				assert object.errors.on(:refusal_reason)
			end
		end
	end

	test "should require other_refusal_reason if " <<
			"refusal_reason == other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:consented => YNDK[:no],
				:refusal_reason => RefusalReason['other'] )
			assert object.errors.on(:other_refusal_reason)
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
			end
		end
	end


	[:yes,:no].each do |yndk|
		test "should require consented_on if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:consented_on => nil)
				assert object.errors.on(:consented_on)
			end
		end
	end
	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW consented_on if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:consented_on => Date.today)
				assert object.errors.on(:consented_on)
			end
		end
	end


	test "should require terminated_reason if " <<
			"terminated_participation == :yes" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:terminated_participation => YNDK[:yes])
			assert object.errors.on(:terminated_reason)
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
			end
		end
	end


	test "should require completed_on if is_complete == :yes" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_complete => YNDK[:yes])
			assert object.errors.on(:completed_on)
		end
	end
	[:no,:dk,:nil].each do |yndk|
		test "should NOT ALLOW completed_on if is_complete == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:is_complete => YNDK[yndk],
					:completed_on => Date.today)
				assert object.errors.on(:completed_on)
			end
		end
	end


	[:dk,:nil].each do |yndk|
		test "should NOT ALLOW document_version_id if consented == #{yndk}" do
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:consented => YNDK[yndk],
					:document_version => Factory(:document_version) )
				assert object.errors.on(:document_version)
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
