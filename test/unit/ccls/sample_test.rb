require 'test_helper'

class Ccls::SampleTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_one( :sample_kit )
	assert_should_have_many( :aliquots )
	assert_should_belong_to( :aliquot_sample_format, :unit, :organization )
	assert_should_initially_belong_to( :study_subject, :sample_type )
	assert_should_habtm( :projects )
	assert_should_require_attributes( :sample_type_id )

#	not working
#	assert_should_require_attributes( :sample_type_id, :study_subject_id )

	test "should require study_subject_id" do
		assert_no_difference "Sample.count" do
			sample = create_sample(:study_subject => nil)
			assert sample.errors.on_attr_and_type(:study_subject_id, :blank)
		end
	end

	assert_should_not_require_attributes( :position,
		:aliquot_sample_format_id,
		:unit_id,
		:order_no,
		:quantity_in_sample,
		:aliquot_or_sample_on_receipt,
		:sent_to_subject_on,
		:received_by_ccls_on,
		:sent_to_lab_on,
		:received_by_lab_on,
		:aliquotted_on,
		:external_id,
		:external_id_source,
		:receipt_confirmed_on,
		:receipt_confirmed_by,
		:collected_on,
		:location_id )

	assert_requires_complete_date( :sent_to_subject_on, 
		:received_by_ccls_on, :sent_to_lab_on,
		:received_by_lab_on, :aliquotted_on,
		:receipt_confirmed_on, :collected_on )
	assert_requires_past_date( :sent_to_subject_on,
		:received_by_ccls_on, :sent_to_lab_on,
		:received_by_lab_on, :aliquotted_on,
		:receipt_confirmed_on, :collected_on )


	test "should require that kit and sample tracking " <<
		"numbers are different" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(:sample_kit_attributes => {
				:kit_package_attributes => {
					:tracking_number => 'bogus_tracking_number'
				},
				:sample_package_attributes => {
					:tracking_number => 'bogus_tracking_number'
				}
			})
			assert sample.errors.on(:base)
			assert_match(/Tracking numbers MUST be different/,
				sample.errors.on(:base) )
		end
	end

	test "should default order_no to 1" do
		sample = create_sample
		assert_equal 1, sample.order_no
	end

	test "should default aliquot_or_sample_on_receipt to 'Sample'" do
		sample = create_sample
		assert_equal 'Sample', sample.aliquot_or_sample_on_receipt
	end

#	somehow

	test "should belong to organization" do
#		sample = create_sample
#		assert_nil sample.organization
#		sample.organization = Factory(:organization)
#		assert_not_nil sample.organization

#	TODO haven't really implemented organization samples yet

		#	this is not clear in my UML diagram

		pending
	end

	test "should require sent_to_subject_on if collected_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_subject_on => nil,
				:collected_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:sent_to_subject_on)
			assert_match(/be blank/,
				sample.errors.on(:sent_to_subject_on) )
		end
	end

	test "should require collected_on be after sent_to_subject_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_subject_on => Chronic.parse('tomorrow'),
				:collected_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:collected_on)
			assert_match(/after sent_to_subject_on/,
				sample.errors.on(:collected_on) )
		end
	end

	test "should require collected_on if received_by_ccls_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:collected_on => nil,
				:received_by_ccls_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:collected_on)
			assert_match(/be blank/,
				sample.errors.on(:collected_on) )
		end
	end

	test "should require received_by_ccls_on be after collected_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:collected_on => Chronic.parse('tomorrow'),
				:received_by_ccls_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:received_by_ccls_on)
			assert_match(/after collected_on/,
				sample.errors.on(:received_by_ccls_on) )
		end
	end

	test "should require received_by_ccls_on if sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_ccls_on => nil,
				:sent_to_lab_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:received_by_ccls_on)
			assert_match(/be blank/,
				sample.errors.on(:received_by_ccls_on) )
		end
	end

	test "should require sent_to_lab_on be after received_by_ccls_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_ccls_on => Chronic.parse('tomorrow'),
				:sent_to_lab_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:sent_to_lab_on)
			assert_match(/after received_by_ccls_on/,
				sample.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require sent_to_lab_on if received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_lab_on => nil,
				:received_by_lab_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:sent_to_lab_on)
			assert_match(/be blank/,
				sample.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require received_by_lab_on be after sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_lab_on => Chronic.parse('tomorrow'),
				:received_by_lab_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:received_by_lab_on)
			assert_match(/after sent_to_lab_on/,
				sample.errors.on(:received_by_lab_on) )
		end
	end

	test "should require location_id be after sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_lab_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:location_id)
			assert_match(/blank/, sample.errors.on(:location_id) )
		end
	end

	test "should require received_by_lab_on if aliquotted_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_lab_on => nil,
				:aliquotted_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:received_by_lab_on)
			assert_match(/be blank/,
				sample.errors.on(:received_by_lab_on) )
		end
	end

	test "should require aliquotted_on be after received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_lab_on => Chronic.parse('tomorrow'),
				:aliquotted_on => Chronic.parse('yesterday')
			)
			assert sample.errors.on(:aliquotted_on)
			assert_match(/after received_by_lab_on/,
				sample.errors.on(:aliquotted_on) )
		end
	end

	test "should create homex outcome with sample" do
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			sample = create_sample(
				:study_subject => create_hx_study_subject() )
		} }
	end

	test "should update homex outcome sample_outcome to sent" do
		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			sample = create_sample(
				:study_subject => create_hx_study_subject(),
				:sent_to_subject_on => Chronic.parse('yesterday') )
			assert_equal SampleOutcome['sent'],
				sample.study_subject.homex_outcome.sample_outcome
			assert_equal sample.sent_to_subject_on,
				sample.study_subject.homex_outcome.sample_outcome_on
		} } }
	end

	test "should update homex outcome sample_outcome to received" do
		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			sample = create_sample(
				:study_subject => create_hx_study_subject(),
				:sent_to_subject_on => Chronic.parse('3 days ago'),
				:collected_on => Chronic.parse('2 days ago'),
				:received_by_ccls_on => Chronic.parse('yesterday') )
			assert_equal SampleOutcome['received'],
				sample.study_subject.homex_outcome.sample_outcome
			assert_equal sample.received_by_ccls_on,
				sample.study_subject.homex_outcome.sample_outcome_on
		} } }
	end

	test "should update homex outcome sample_outcome to lab" do
#		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			sample = create_sample(
				:study_subject => create_hx_study_subject(),
				:organization => Factory(:organization),
				:sent_to_subject_on => Chronic.parse('4 days ago'),
				:collected_on => Chronic.parse('3 days ago'),
				:received_by_ccls_on => Chronic.parse('2 days ago'),
				:sent_to_lab_on => Chronic.parse('yesterday') )
			assert !sample.new_record?, "Object was not created"
			assert_equal SampleOutcome['lab'],
				sample.study_subject.homex_outcome.sample_outcome
			assert_equal sample.sent_to_lab_on,
				sample.study_subject.homex_outcome.sample_outcome_on
		} } #}
	end

	test "should respond to sample_type_parent" do
		sample = create_sample
		assert sample.respond_to? :sample_type_parent
		sample_type_parent = sample.sample_type_parent
		assert_not_nil sample_type_parent
		assert sample_type_parent.is_a?(SampleType)
	end

	test "should respond to kit_sent_on" do
		sample = create_sample
		assert sample.respond_to? :kit_sent_on
		assert_nil sample.kit_sent_on
	end

	test "should respond to kit_received_on" do
		sample = create_sample
		assert sample.respond_to? :kit_received_on
		assert_nil sample.kit_received_on
	end

	test "should respond to sample_sent_on" do
		sample = create_sample
		assert sample.respond_to? :sample_sent_on
		assert_nil sample.sample_sent_on
	end

	test "should respond to sample_received_on" do
		sample = create_sample
		assert sample.respond_to? :sample_received_on
		assert_nil sample.sample_received_on
	end

protected

	def create_sample(options={})
		sample = Factory.build(:sample,options)
		sample.save
		sample
	end

end
