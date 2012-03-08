require 'test_helper'

class Ccls::AddressingTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_protect(:study_subject_id, :study_subject)
	assert_should_not_require_attributes( 
		:address_id,
		:current_address,
		:address_at_diagnosis,
		:is_valid,
		:why_invalid,
		:is_verified,
		:how_verified,
		:valid_from,
		:valid_to,
		:verified_on,
		:verified_by_uid )
#		:data_source_id )
	assert_should_initially_belong_to( 
		:study_subject, 
		:address )
	assert_should_require_attribute_length( 
		:why_invalid, 
		:how_verified, 
			:maximum => 250 )
	assert_requires_complete_date( 
		:valid_from, 
		:valid_to )

	test "explicit Factory addressing test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Address.count',1) {
		assert_difference('Addressing.count',1) {
			addressing = Factory(:addressing)
			assert_not_nil addressing.address
			assert_not_nil addressing.study_subject
			assert_equal 1, addressing.is_valid
#			assert_equal 2, addressing.is_verified
			assert         !addressing.is_verified	#	noticed that this is NOT int for YNDK, but boolean
		} } }
	end

	test "explicity Factory mailing_addressing test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Address.count',1) {
		assert_difference('Addressing.count',1) {
			addressing = Factory(:mailing_addressing)
			assert_equal addressing.address.address_type,
				AddressType['mailing']
			assert_equal addressing.current_address, YNDK[:no]
		} } }
	end

	test "explicity Factory current_mailing_addressing test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Address.count',1) {
		assert_difference('Addressing.count',1) {
			addressing = Factory(:current_mailing_addressing)
			assert_equal addressing.address.address_type,
				AddressType['mailing']
			assert_equal addressing.current_address, YNDK[:yes]
		} } }
	end

	test "explicity Factory residence_addressing test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Address.count',1) {
		assert_difference('Addressing.count',1) {
			addressing = Factory(:residence_addressing)
			assert_equal addressing.address.address_type,
				AddressType['residence']
			assert_equal addressing.current_address, YNDK[:no]
		} } }
	end

	test "explicity Factory current_residence_addressing test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Address.count',1) {
		assert_difference('Addressing.count',1) {
			addressing = Factory(:current_residence_addressing)
			assert_equal addressing.address.address_type,
				AddressType['residence']
			assert_equal addressing.current_address, YNDK[:yes]
		} } }
	end

	test "current_address should default to 1" do
		addressing = Addressing.new
		assert_equal 1, addressing.current_address
	end

	#
	# addressing uses accepts_attributes_for :address
	# so the addressing can't require address_id on create
	# or this test fails.
	#
#	test "should require address on update" do
#		assert_difference("Addressing.count", 1 ) do
#			addressing = create_addressing(:address_id => nil)
#			addressing.reload.update_attributes(
#				:created_at => Date.yesterday )
#			assert addressing.errors.on(:address)
#		end
#	end


	test "should require data_source_other if data_source is other" do
		assert_difference( "Addressing.count", 0 ) {
#		assert_difference( "Address.count", 0 ) {
			#	The factory will create the associations regardless
			#	so an Address and StudySubject gets created regardless
			addressing = create_addressing( :data_source => DataSource['Other'] )
			assert addressing.errors.on_attr_and_type?(:data_source_other,:blank)
		} # }
	end

	test "should NOT require data_source_other if data_source is not other" do
		assert_difference( "Address.count", 1 ) {
		assert_difference( "Addressing.count", 1 ) {
			addressing = create_addressing( :data_source => DataSource['raf'])
			assert !addressing.errors.on_attr_and_type?(:data_source_other,:blank)
		} }
	end

	test "should require a valid address with address_attributes" do
		assert_difference("Address.count", 0 ) {
		assert_difference("Addressing.count", 0 ) {
			addressing = create_addressing(:address_id => nil,
				:address_attributes => {} )
		} }
	end

	[:yes,:nil].each do |yndk|
		test "should NOT require why_invalid if is_valid is #{yndk}" do
			assert_difference("Addressing.count", 1 ) do
				addressing = create_addressing(:is_valid => YNDK[yndk])
			end
		end
	end
	[:no,:dk].each do |yndk|
		test "should require why_invalid if is_valid is #{yndk}" do
			assert_difference("Addressing.count", 0 ) do
				addressing = create_addressing(:is_valid => YNDK[yndk])
				assert addressing.errors.on(:why_invalid)
			end
		end
	end

	test "should NOT require how_verified if is_verified is false" do
		assert_difference("Addressing.count", 1 ) do
			addressing = create_addressing(:is_verified => false)
		end
	end
	test "should require how_verified if is_verified is true" do
		assert_difference("Addressing.count", 0 ) do
			addressing = create_addressing(:is_verified => true)
			assert addressing.errors.on(:how_verified)
		end
	end


	test "should NOT set verified_on if is_verified NOT changed to true" do
		addressing = create_addressing(:is_verified => false)
		assert_nil addressing.verified_on
	end


	test "should set verified_on if is_verified changed to true" do
		addressing = create_addressing(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil addressing.verified_on
	end

	test "should set verified_on to NIL if is_verified changed to false" do
		addressing = create_addressing(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil addressing.verified_on
		addressing.update_attributes(:is_verified => false)
		assert_nil addressing.verified_on
	end

	test "should NOT set verified_by_uid if is_verified NOT changed to true" do
		addressing = create_addressing(:is_verified => false)
		assert_nil addressing.verified_by_uid
	end

	test "should set verified_by_uid to 0 if is_verified changed to true" do
		addressing = create_addressing(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil addressing.verified_by_uid
		assert_equal addressing.verified_by_uid, ''
	end

	test "should set verified_by_uid to current_user.id if is_verified " <<
		"changed to true if current_user passed" do
		cu = admin_user
		addressing = create_addressing(:is_verified => true,
			:current_user => cu,
			:how_verified => "not a clue")
		assert_not_nil addressing.verified_by_uid
		assert_equal addressing.verified_by_uid, cu.uid
	end

	test "should set verified_by_uid to NIL if is_verified changed to false" do
		addressing = create_addressing(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil addressing.verified_by_uid
		addressing.update_attributes(:is_verified => false)
		assert_nil addressing.verified_by_uid
	end


	test "should only return current addressings" do
		create_addressing(:current_address => YNDK[:yes])
		create_addressing(:current_address => YNDK[:no])
		create_addressing(:current_address => YNDK[:dk])
		addressing = Addressing.current
		assert_equal 2, addressing.length
		addressing.each do |addressing|
			assert [1,999].include?(addressing.current_address)
		end
	end

	test "should only return historic addressings" do
		create_addressing(:current_address => YNDK[:yes])
		create_addressing(:current_address => YNDK[:no])
		create_addressing(:current_address => YNDK[:dk])
		addressing = Addressing.historic
		assert_equal 1, addressing.length
		addressing.each do |addressing|
			assert ![1,999].include?(addressing.current_address)
		end
	end

	test "should make study_subject ineligible "<<
			"on create if state NOT 'CA' and address is ONLY residence" do
		study_subject = create_eligible_hx_study_subject
		assert_difference('OperationalEvent.count',1) {
		assert_difference('Addressing.count',1) {
		assert_difference('Address.count',1) {
			create_az_addressing(study_subject)
		} } }
		assert_study_subject_is_not_eligible(study_subject)
		hxe = study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id)
		assert_equal   hxe.ineligible_reason,
			IneligibleReason['newnonCA']
	end

	test "should make study_subject ineligible "<<
			"on create if state NOT 'CA' and address is ANOTHER residence" do
		study_subject = create_eligible_hx_study_subject
		assert_difference('OperationalEvent.count',1) {
		assert_difference('Address.count',2) {
		assert_difference("Addressing.count", 2 ) {
			create_ca_addressing(study_subject)
			create_az_addressing(study_subject)
		} } }
		assert_study_subject_is_not_eligible(study_subject)
		hxe = study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id)
		assert_equal   hxe.ineligible_reason,
			IneligibleReason['moved']
	end

	test "should NOT make study_subject ineligible "<<
			"on create if OET is missing" do
		OperationalEventType['ineligible'].destroy
		study_subject = create_eligible_hx_study_subject
		assert_difference('OperationalEvent.count',0) {
		assert_difference('Address.count',1) {
		assert_difference("Addressing.count", 1 ) {
			create_ca_addressing(study_subject)
			assert_raise(ActiveRecord::RecordNotSaved){
				create_az_addressing(study_subject)
		} } } }
		assert_study_subject_is_eligible(study_subject)
	end

	test "should NOT make study_subject ineligible "<<
			"on create if state NOT 'CA' and address is NOT residence" do
		study_subject = create_eligible_hx_study_subject
		assert_difference('OperationalEvent.count',0) {
		assert_difference('Address.count',1) {
		assert_difference("Addressing.count", 1 ) {
			create_az_addressing(study_subject,
				:address => { :address_type => AddressType['mailing'] })
		} } }
		assert_study_subject_is_eligible(study_subject)
	end

	test "should NOT make study_subject ineligible "<<
			"on create if state 'CA' and address is residence" do
		study_subject = create_eligible_hx_study_subject
		assert_difference('OperationalEvent.count',0) {
		assert_difference('Address.count',1) {
		assert_difference("Addressing.count", 1 ) {
			create_ca_addressing(study_subject)
		} } }
		assert_study_subject_is_eligible(study_subject)
	end

	%w( address_type address_type_id
			line_1 line_2 unit city state zip csz county ).each do |method_name|
		test "should respond to #{method_name}" do
			addressing = create_addressing
			assert addressing.respond_to?(method_name)
		end
	end


#	'1' and '0' are the default values for a checkbox.
#	I probably should add a condition to this event that
#	the address_type be 'Residence', but I've left that to the view.
#			addressing = Factory(:current_residence_addressing)

	test "should NOT add 'subject_moved' event to subject if subject_moved is '1'" <<
			" if not residence address" do
		addressing = Factory(:current_mailing_addressing)
		assert_difference('OperationalEvent.count',0) {
			addressing.update_attributes(
				:current_address => '2',
				:subject_moved => '1')
		}
	end

	test "should NOT add 'subject_moved' event to subject if subject_moved is '1'" <<
			" if was not current address" do
		addressing = Factory(:residence_addressing)
		assert_difference('OperationalEvent.count',0) {
			addressing.update_attributes(
				:current_address => '2',
				:subject_moved => '1')
		}
	end

	test "should add 'subject_moved' event to subject if subject_moved is '1'" do
		addressing = Factory(:current_residence_addressing)
		assert_difference('OperationalEvent.count',1) {
			addressing.update_attributes(
				:current_address => '2',
				:subject_moved => '1')
		}
	end

	test "should not add 'subject_moved' event to subject if subject_moved is '0'" do
		addressing = Factory(:current_residence_addressing)
		assert_difference('OperationalEvent.count',0) {
			addressing.update_attributes(
				:current_address => '2',
				:subject_moved => '0')
		}
	end

	test "should add 'subject_moved' event to subject if subject_moved is 'true'" do
		addressing = Factory(:current_residence_addressing)
		assert_difference('OperationalEvent.count',1) {
			addressing.update_attributes(
				:current_address => '2',
				:subject_moved => 'true')
		}
	end

	test "should not add 'subject_moved' event to subject if subject_moved is 'false'" do
		addressing = Factory(:current_residence_addressing)
		assert_difference('OperationalEvent.count',0) {
			addressing.update_attributes(
				:current_address => '2',
				:subject_moved => 'false')
		}
	end

	test "should not add 'subject_moved' event to subject if subject_moved is nil" do
		addressing = Factory(:current_residence_addressing)
		assert_difference('OperationalEvent.count',0) {
			addressing.update_attributes(
				:current_address => '2',
				:subject_moved => nil)
		}
	end

	#	current_address has a database default of 1
	[ :current_address ].each do |field|

		#	Making assumption that 12345 will NEVER be a valid value.
		test "should NOT allow 12345 for #{field}" do
			addressing = Addressing.new(field => 12345)
			addressing.valid?
			assert addressing.errors.on_attr_and_type?(field,:inclusion)
		end

#		test "should allow nil for #{field}" do
#			addressing = Addressing.new(field => nil)
#			assert_nil addressing.send(field)
#			addressing.valid?
#			assert !addressing.errors.on(field)
#		end

		test "should allow all valid YNDK values for #{field}" do
			addressing = Addressing.new
			YNDK.valid_values.each do |value|
				addressing.send("#{field}=", value)
				addressing.valid?
				assert !addressing.errors.on(field)
			end
		end

	end

	[ :is_valid, :address_at_diagnosis ].each do |field|

		#	Making assumption that 12345 will NEVER be a valid value.
		test "should NOT allow 12345 for #{field}" do
			addressing = Addressing.new(field => 12345)
			addressing.valid?
			assert addressing.errors.on_attr_and_type?(field,:inclusion)
		end

		test "should allow nil for #{field}" do
			addressing = Addressing.new(field => nil)
			assert_nil addressing.send(field)
			addressing.valid?
			assert !addressing.errors.on(field)
		end

		test "should allow all valid YNDK values for #{field}" do
			addressing = Addressing.new
			YNDK.valid_values.each do |value|
				addressing.send("#{field}=", value)
				addressing.valid?
				assert !addressing.errors.on(field)
			end
		end

	end

protected

#	def create_addressing(options={})
#		addressing = Factory.build(:addressing,options)
#		addressing.save
#		addressing
#	end

	def create_addressing_with_address(study_subject,options={})
		create_addressing({
			:study_subject => study_subject,
#	doesn't work in rcov for some reason
#			:address => nil,	#	block address_attributes
			:address_id => nil,	#	block address_attributes
			:address_attributes => Factory.attributes_for(:address,{
				:address_type => AddressType['residence']
			}.merge(options[:address]||{}))
		}.merge(options[:addressing]||{}))
	end

	def create_ca_addressing(study_subject,options={})
		create_addressing_with_address(study_subject,{
			:address => {:state => 'CA'}}.merge(options))
	end

	def create_az_addressing(study_subject,options={})
		create_addressing_with_address(study_subject,{
			:address => {:state => 'AZ'}}.merge(options))
	end

end
