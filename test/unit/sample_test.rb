require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_one( :sample_kit )
	assert_should_have_many( :aliquots )
	assert_should_belong_to( :aliquot_sample_format )
	assert_should_belong_to( :unit )
	assert_should_initially_belong_to( :subject )
	assert_should_initially_belong_to( :sample_type )
	assert_should_habtm( :projects )
	assert_should_require_attributes( :sample_type_id )
	assert_should_require_attributes( :study_subject_id )

	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :aliquot_sample_format_id )
	assert_should_not_require_attributes( :unit_id )
	assert_should_not_require_attributes( :order_no )
	assert_should_not_require_attributes( :quantity_in_sample )
	assert_should_not_require_attributes( :aliquot_or_sample_on_receipt )
	assert_should_not_require_attributes( :sent_to_subject_on )
	assert_should_not_require_attributes( :received_by_ccls_on )
	assert_should_not_require_attributes( :sent_to_lab_on )
	assert_should_not_require_attributes( :received_by_lab_on )
	assert_should_not_require_attributes( :aliquotted_on )
	assert_should_not_require_attributes( :external_id )
	assert_should_not_require_attributes( :external_id_source )
	assert_should_not_require_attributes( :receipt_confirmed_on )
	assert_should_not_require_attributes( :receipt_confirmed_by )

	assert_requires_complete_date( :sent_to_subject_on )
	assert_requires_complete_date( :received_by_ccls_on )
	assert_requires_complete_date( :sent_to_lab_on )
	assert_requires_complete_date( :received_by_lab_on )
	assert_requires_complete_date( :aliquotted_on )
	assert_requires_complete_date( :receipt_confirmed_on )

	test "should require that kit and sample tracking " <<
		"numbers are different" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(:sample_kit_attributes => {
				:kit_package_attributes => {
					:tracking_number => 'bogus_tracking_number'
				},
				:sample_package_attributes => {
					:tracking_number => 'bogus_tracking_number'
				}
			})
			assert object.errors.on(:base)
			assert_match(/Tracking numbers MUST be different/,
				object.errors.on(:base) )
		end
	end

	test "should default order_no to 1" do
		object = create_object
		assert_equal 1, object.order_no
	end

	test "should default aliquot_or_sample_on_receipt to 'Sample'" do
		object = create_object
		assert_equal 'Sample', object.aliquot_or_sample_on_receipt
	end

#	somehow

	test "should belong to organization" do
#		object = create_object
#		assert_nil object.organization
#		object.organization = Factory(:organization)
#		assert_not_nil object.organization

#	TODO

		#	this is not clear in my UML diagram

		pending
	end

	test "should require sent_to_subject_on if received_by_ccls_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_subject_on => nil,
				:received_by_ccls_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:sent_to_subject_on)
			assert_match(/be blank/,
				object.errors.on(:sent_to_subject_on) )
		end
	end

	test "should require received_by_ccls_on be after sent_to_subject_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_subject_on => Chronic.parse('tomorrow'),
				:received_by_ccls_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_ccls_on)
			assert_match(/after sent_to_subject_on/,
				object.errors.on(:received_by_ccls_on) )
		end
	end

	test "should require received_by_ccls_on if sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_ccls_on => nil,
				:sent_to_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_ccls_on)
			assert_match(/be blank/,
				object.errors.on(:received_by_ccls_on) )
		end
	end

	test "should require sent_to_lab_on be after received_by_ccls_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_ccls_on => Chronic.parse('tomorrow'),
				:sent_to_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:sent_to_lab_on)
			assert_match(/after received_by_ccls_on/,
				object.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require sent_to_lab_on if received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_lab_on => nil,
				:received_by_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:sent_to_lab_on)
			assert_match(/be blank/,
				object.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require received_by_lab_on be after sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_lab_on => Chronic.parse('tomorrow'),
				:received_by_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_lab_on)
			assert_match(/after sent_to_lab_on/,
				object.errors.on(:received_by_lab_on) )
		end
	end

	test "should require received_by_lab_on if aliquotted_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_lab_on => nil,
				:aliquotted_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_lab_on)
			assert_match(/be blank/,
				object.errors.on(:received_by_lab_on) )
		end
	end

	test "should require aliquotted_on be after received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_lab_on => Chronic.parse('tomorrow'),
				:aliquotted_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:aliquotted_on)
			assert_match(/after received_by_lab_on/,
				object.errors.on(:aliquotted_on) )
		end
	end

	test "should create homex outcome with sample" do
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			object = create_object(
				:subject => create_hx_subject() )
		} }
	end

	test "should update homex outcome sample_outcome to sent" do
		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			object = create_object(
				:subject => create_hx_subject(),
				:sent_to_subject_on => Chronic.parse('yesterday') )
			assert_equal SampleOutcome['sent'],
				object.subject.homex_outcome.sample_outcome
			assert_equal object.sent_to_subject_on,
				object.subject.homex_outcome.sample_outcome_on
		} } }
	end

	test "should update homex outcome sample_outcome to received" do
		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			object = create_object(
				:subject => create_hx_subject(),
				:sent_to_subject_on => Chronic.parse('2 days ago'),
				:received_by_ccls_on => Chronic.parse('yesterday') )
			assert_equal SampleOutcome['received'],
				object.subject.homex_outcome.sample_outcome
			assert_equal object.received_by_ccls_on,
				object.subject.homex_outcome.sample_outcome_on
		} } }
	end

	test "should update homex outcome sample_outcome to lab" do
#		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			object = create_object(
				:subject => create_hx_subject(),
				:sent_to_subject_on => Chronic.parse('3 days ago'),
				:received_by_ccls_on => Chronic.parse('2 days ago'),
				:sent_to_lab_on => Chronic.parse('yesterday') )
			assert_equal SampleOutcome['lab'],
				object.subject.homex_outcome.sample_outcome
			assert_equal object.sent_to_lab_on,
				object.subject.homex_outcome.sample_outcome_on
		} } #}
	end

end
