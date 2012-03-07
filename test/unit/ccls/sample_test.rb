require 'test_helper'

class Ccls::SampleTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_one( :sample_kit )
	assert_should_have_many( :aliquots )
	assert_should_belong_to( :aliquot_sample_format, :unit, :organization )
	assert_should_initially_belong_to( :study_subject, :sample_type )
	assert_should_habtm( :projects )
#	assert_should_require_attributes( :sample_type_id, :study_subject_id )

	assert_should_not_require_attributes( :position,
		:aliquot_sample_format_id,
		:unit_id,
		:order_no,
		:quantity_in_sample,
		:aliquot_or_sample_on_receipt,
		:sent_to_subject_on,
		:collected_at,
		:received_by_ccls_at,
		:sent_to_lab_on,
		:received_by_lab_on,
		:aliquotted_on,
		:external_id,
		:external_id_source,
		:receipt_confirmed_on,
		:receipt_confirmed_by,
		:location_id )

	assert_requires_complete_date( :sent_to_subject_on, 
		:received_by_ccls_at, :sent_to_lab_on,
		:received_by_lab_on, :aliquotted_on,
		:receipt_confirmed_on, :collected_at )

	assert_requires_past_date( :sent_to_subject_on,
		:received_by_ccls_at, :sent_to_lab_on,
		:received_by_lab_on, :aliquotted_on,
		:receipt_confirmed_on, :collected_at )

	test "explicit Factory sample test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('SampleType.count',2) {	#	creates sample_type and a parent sample_type
		assert_difference('Sample.count',1) {
			sample = Factory(:sample)
			assert_not_nil sample.sample_type
			assert_not_nil sample.sample_type.parent
			assert_not_nil sample.study_subject
		} } }
	end

	test "should require sample_type" do
		assert_difference( "Sample.count", 0 ) do
			sample = create_sample( :sample_type => nil)
			assert !sample.errors.on(:sample_type)
			assert  sample.errors.on_attr_and_type?(:sample_type_id,:blank)
		end
	end

	test "should require valid sample_type" do
		assert_difference( "Sample.count", 0 ) do
			sample = create_sample( :sample_type_id => 0)
			assert !sample.errors.on(:sample_type_id)
			assert  sample.errors.on_attr_and_type?(:sample_type,:blank)
		end
	end

	test "should require study_subject" do
		assert_difference( "Sample.count", 0 ) do
			sample = create_sample( :study_subject => nil)
			assert !sample.errors.on(:study_subject)
			assert  sample.errors.on_attr_and_type?(:study_subject_id,:blank)
		end
	end

	test "should require valid study_subject" do
		assert_difference( "Sample.count", 0 ) do
			sample = create_sample( :study_subject_id => 0)
			assert !sample.errors.on(:study_subject_id)
			assert  sample.errors.on_attr_and_type?(:study_subject,:blank)
		end
	end

#	20120213 - No more packages. 
#	MAY maintain tracking numbers in kit later.
#	test "should require that kit and sample tracking " <<
#		"numbers are different" do
#		assert_difference( 'Sample.count', 0 ) do
#			sample = create_sample(:sample_kit_attributes => {
#				:kit_package_attributes => {
#					:tracking_number => 'bogus_tracking_number'
#				},
#				:sample_package_attributes => {
#					:tracking_number => 'bogus_tracking_number'
#				}
#			})
#			assert sample.errors.on(:base)
#			assert_match(/Tracking numbers MUST be different/,
#				sample.errors.on(:base) )
#		end
#	end

	test "should default order_no to 1" do
		sample = create_sample
		assert_equal 1, sample.order_no
	end

	test "should default aliquot_or_sample_on_receipt to 'Sample'" do
		sample = create_sample
		assert_equal 'Sample', sample.aliquot_or_sample_on_receipt
	end

#	somehow

#	TODO haven't really implemented organization samples yet
#	test "should belong to organization" do
#		sample = create_sample
#		assert_nil sample.organization
#		sample.organization = Factory(:organization)
#		assert_not_nil sample.organization
#		#	this is not clear in my UML diagram
#		pending
#	end

	test "should require sent_to_subject_on if collected_at" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_subject_on => nil,
				:collected_at => Date.yesterday
			)
			assert sample.errors.on(:sent_to_subject_on)
			assert_match(/be blank/,
				sample.errors.on(:sent_to_subject_on) )
		end
	end

	test "should require collected_at be after sent_to_subject_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_subject_on => Date.tomorrow,
				:collected_at => Date.yesterday
			)
			assert sample.errors.on(:collected_at)
			assert_match(/after sent_to_subject_on/,
				sample.errors.on(:collected_at) )
		end
	end

	test "should require collected_at if received_by_ccls_at" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:collected_at => nil,
				:received_by_ccls_at => Date.yesterday
			)
			assert sample.errors.on(:collected_at)
			assert_match(/be blank/,
				sample.errors.on(:collected_at) )
		end
	end

	test "should require received_by_ccls_at be after collected_at" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:collected_at => Date.tomorrow,
				:received_by_ccls_at => Date.yesterday
			)
			assert sample.errors.on(:received_by_ccls_at)
			assert_match(/after collected_at/,
				sample.errors.on(:received_by_ccls_at) )
		end
	end

	test "should require received_by_ccls_at if sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_ccls_at => nil,
				:sent_to_lab_on => Date.yesterday
			)
			assert sample.errors.on(:received_by_ccls_at)
			assert_match(/be blank/,
				sample.errors.on(:received_by_ccls_at) )
		end
	end

	test "should require sent_to_lab_on be after received_by_ccls_at" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_ccls_at => Date.tomorrow,
				:sent_to_lab_on => Date.yesterday
			)
			assert sample.errors.on(:sent_to_lab_on)
			assert_match(/after received_by_ccls_at/,
				sample.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require sent_to_lab_on if received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_lab_on => nil,
				:received_by_lab_on => Date.yesterday
			)
			assert sample.errors.on(:sent_to_lab_on)
			assert_match(/be blank/,
				sample.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require received_by_lab_on be after sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_lab_on => Date.tomorrow,
				:received_by_lab_on => Date.yesterday
			)
			assert sample.errors.on(:received_by_lab_on)
			assert_match(/after sent_to_lab_on/,
				sample.errors.on(:received_by_lab_on) )
		end
	end

	test "should require location_id be after sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:sent_to_lab_on => Date.yesterday
			)
			assert sample.errors.on(:location_id)
			assert_match(/blank/, sample.errors.on(:location_id) )
		end
	end

	test "should require received_by_lab_on if aliquotted_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_lab_on => nil,
				:aliquotted_on => Date.yesterday
			)
			assert sample.errors.on(:received_by_lab_on)
			assert_match(/be blank/,
				sample.errors.on(:received_by_lab_on) )
		end
	end

	test "should require aliquotted_on be after received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			sample = create_sample(
				:received_by_lab_on => Date.tomorrow,
				:aliquotted_on => Date.yesterday
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
		study_subject = create_hx_study_subject
		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			sample = create_sample(
				:study_subject => study_subject,
				:sent_to_subject_on => Date.yesterday )
			assert_equal SampleOutcome['sent'],
				sample.study_subject.homex_outcome.sample_outcome
			assert_equal sample.sent_to_subject_on,
				sample.study_subject.homex_outcome.sample_outcome_on
		} } }
	end

	test "should update homex outcome sample_outcome to received" do
		study_subject = create_hx_study_subject
		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			today = Date.today
			sample = create_sample(
				:study_subject => study_subject,
				:sent_to_subject_on => ( today - 3.days ),
				:collected_at => ( today - 2.days ),
				:received_by_ccls_at => ( today - 1.day ) )
			assert_equal SampleOutcome['received'],
				sample.study_subject.homex_outcome.sample_outcome
			assert_equal sample.received_by_ccls_at,
				sample.study_subject.homex_outcome.sample_outcome_on
		} } }
	end

	test "should update homex outcome sample_outcome to lab" do
		study_subject = create_hx_study_subject
#	This update does not create an operational event
#		assert_difference( 'OperationalEvent.count', 1 ) {
		assert_difference( 'Sample.count', 1 ) {
		assert_difference( 'HomexOutcome.count', 1 ) {
			today = Date.today
			sample = create_sample(
				:study_subject => study_subject,
				:organization => Factory(:organization),
				:sent_to_subject_on => ( today - 4.days ),
				:collected_at => ( today - 3.days ),
				:received_by_ccls_at => ( today - 2.days ),
				:sent_to_lab_on => ( today - 1.day ) )
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

#	20120213 - were delegated to packages.
#	MAY keep this data in kit later.
#	test "should respond to kit_sent_on" do
#		sample = create_sample
#		assert sample.respond_to? :kit_sent_on
#		assert_nil sample.kit_sent_on
#	end
#
#	test "should respond to kit_received_on" do
#		sample = create_sample
#		assert sample.respond_to? :kit_received_on
#		assert_nil sample.kit_received_on
#	end
#
#	test "should respond to sample_sent_on" do
#		sample = create_sample
#		assert sample.respond_to? :sample_sent_on
#		assert_nil sample.sample_sent_on
#	end
#
#	test "should respond to sample_received_on" do
#		sample = create_sample
#		assert sample.respond_to? :sample_received_on
#		assert_nil sample.sample_received_on
#	end

#protected
#
#	def create_sample(options={})
#		sample = Factory.build(:sample,options)
#		sample.save
#		sample
#	end

end
