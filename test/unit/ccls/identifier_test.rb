require 'test_helper'

class Ccls::IdentifierTest < ActiveSupport::TestCase

#	assert_should_require :hospital_no
	assert_should_not_require :hospital_no

	assert_should_create_default_object
	assert_should_not_require_attributes( :case_control_type )
	assert_should_require_unique_attribute( 
		:ssn,
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:gbid,
		:lab_no_wiemels,
		:accession_no,
		:idno_wiemels,
		:icf_master_id )
	assert_should_initially_belong_to( :study_subject )
	assert_should_protect( :study_subject_id )
	assert_should_not_require_attributes( 
		:ssn,
		:subjectid,
		:lab_no,
		:related_childid,
		:related_case_childid,
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:matchingid,
		:gbid,
		:lab_no_wiemels,
		:accession_no,
		:idno_wiemels,
		:familyid )
	assert_should_require_attribute_length( 
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:lab_no,
		:related_childid,
		:related_case_childid,
			:maximum => 250 )
	assert_should_require_attribute_length :childidwho, :maximum => 10
	assert_should_require_attribute_length :newid, :maximum => 6
	assert_should_require_attribute_length :gbid, :maximum => 26
	assert_should_require_attribute_length :lab_no_wiemels, :maximum => 25
	assert_should_require_attribute_length :hospital_no, :maximum => 25
	assert_should_require_attribute_length :idno_wiemels, :maximum => 10
	assert_should_require_attribute_length :accession_no, :maximum => 25
	assert_should_require_attribute_length :icf_master_id, :maximum => 9

	assert_should_protect_attributes(
		:studyid,
		:studyid_nohyphen,
		:studyid_intonly_nohyphen,
		:familyid,
		:childid,
		:subjectid,
		:patid )

	test "should nullify blank ssn before validation" do
		identifier = Factory.build(:identifier, :ssn => '')
		assert  identifier.ssn.blank?
		assert !identifier.ssn.nil?
		identifier.valid?
		assert  identifier.ssn.blank?
		assert  identifier.ssn.nil?
	end 

	test "should nullify blank state_id_no before validation" do
		identifier = Factory.build(:identifier, :state_id_no => '')
		assert  identifier.state_id_no.blank?
		assert !identifier.state_id_no.nil?
		identifier.valid?
		assert  identifier.state_id_no.blank?
		assert  identifier.state_id_no.nil?
	end 

	test "should nullify blank state_registrar_no before validation" do
		identifier = Factory.build(:identifier, :state_registrar_no => '')
		assert  identifier.state_registrar_no.blank?
		assert !identifier.state_registrar_no.nil?
		identifier.valid?
		assert  identifier.state_registrar_no.blank?
		assert  identifier.state_registrar_no.nil?
	end 

	test "should nullify blank local_registrar_no before validation" do
		identifier = Factory.build(:identifier, :local_registrar_no => '')
		assert  identifier.local_registrar_no.blank?
		assert !identifier.local_registrar_no.nil?
		identifier.valid?
		assert  identifier.local_registrar_no.blank?
		assert  identifier.local_registrar_no.nil?
	end 

#	test "should pad subjectid with leading zeros before validation" do
#		identifier = Factory.build(:identifier)
#		assert identifier.subjectid.length < 6 
#		identifier.valid?	#save
#		assert identifier.subjectid.length == 6
#	end 

	test "should pad matchingid with leading zeros before validation" do
		identifier = Factory.build(:identifier,{ :matchingid => '123' })
		assert identifier.matchingid.length < 6 
		assert_equal '123', identifier.matchingid
		identifier.valid?	#save
		assert identifier.matchingid.length == 6
		assert_equal '000123', identifier.matchingid
	end 

	test "should pad patid with leading zeros before validation" do
		identifier = Factory.build(:identifier)
		identifier.patid = '123'
		assert identifier.patid.length < 4
		assert_equal '123', identifier.patid
		identifier.valid?	#save
		assert identifier.patid.length == 4
		assert_equal '0123', identifier.patid
	end 

	test "should create with all numeric ssn" do
		assert_difference( "Identifier.count", 1 ) do
			identifier = create_identifier(:ssn => 987654321)
			assert !identifier.new_record?, 
				"#{identifier.errors.full_messages.to_sentence}"
			assert_equal '987654321', identifier.reload.ssn
		end
	end

	test "should create with string all numeric ssn" do
		assert_difference( "Identifier.count", 1 ) do
			identifier = create_identifier(:ssn => '987654321')
			assert !identifier.new_record?, 
				"#{identifier.errors.full_messages.to_sentence}"
			assert_equal '987654321', identifier.reload.ssn
		end
	end

	test "should create with string standard format ssn" do
		assert_difference( "Identifier.count", 1 ) do
			identifier = create_identifier(:ssn => '987-65-4321')
			assert !identifier.new_record?, 
				"#{identifier.errors.full_messages.to_sentence}"
			assert_equal '987654321', identifier.reload.ssn
		end
	end

	test "should remove non-numeric chars from ssn before validation" do
		identifier = Factory.build(:identifier, :ssn => '1s2n3-4k5=6;7sdfg8  9  ')
		assert identifier.ssn.length > 9
		assert '123456789' != identifier.ssn
		identifier.valid?
		assert identifier.ssn.length == 9
		assert '123456789' == identifier.ssn
	end 

	#	TODO "should require 9 digits in ssn" do
	test "should require 9 digits in ssn" do
pending
#		%w( 12345678X 12345678 1-34-56-789 ).each do |invalid_ssn|
#			assert_difference( "Identifier.count", 0 ) do
#				identifier = create_identifier(:ssn => invalid_ssn)
#				assert identifier.errors.on(:ssn)
#			end
#		end
	end

	test "should increment Childid.next_id on get_next_childid" do
		assert_difference('Childid.next_id', 1) {
			#	use send as is protected
			Identifier.new.send(:get_next_childid)
		}
	end

	test "should increment Patid.next_id on get_next_patid" do
		assert_difference('Patid.next_id', 1) {
			#	use send as is protected
			Identifier.new.send(:get_next_patid)
		}
	end

	test "should be case with case_control_type == 'C'" do
		identifier = Identifier.new(:case_control_type => 'C')
		assert identifier.is_case?
	end

	test "should be mother with case_control_type == 'M'" do
		identifier = Identifier.new(:case_control_type => 'M')
		assert identifier.is_mother?
	end

	test "should be mother with case_control_type == nil" do
		identifier = Identifier.new(:case_control_type => nil )
		assert identifier.is_mother?
	end

	%w( B F 4 5 6 ).each do |cct|
		test "should be control with case_control_type == '#{cct}'" do
			identifier = Identifier.new(:case_control_type => cct )
			assert identifier.is_control?
		end

		test "should NOT generate patid on creation of case_control_type == '#{cct}'" do
			assert_difference('Patid.next_id', 0) {
				identifier = Factory(:identifier, :case_control_type => cct )
				assert_nil identifier.patid
			}
		end
	end

	test "should NOT generate patid on creation of case_control_type == nil" do
		assert_difference('Patid.next_id', 0) {
			identifier = Factory(:identifier, :case_control_type => nil )
			assert_nil identifier.patid
		}
	end

	test "should NOT generate patid on creation of case_control_type == 'M'" do
		assert_difference('Patid.next_id', 0) {
			identifier = Factory(:identifier, :case_control_type => 'M' )
			assert_nil identifier.patid
		}
	end

#	patid and childid should be protected as they are generated values

	test "should generate orderno = 0 for case_control_type == 'c'" do
		identifier = Factory(:case_identifier).reload
		assert_equal 0, identifier.orderno
	end

	test "should NOT set studyid with patid, case_control_type and orderno for" <<
			" case_control_type c" do
		Identifier.any_instance.stubs(:get_next_patid).returns('123')
		identifier = Factory(:case_identifier).reload
		assert_equal "0123", identifier.patid
		assert_equal "0123-C-0", identifier.studyid
		assert_equal "0123C0",   identifier.studyid_nohyphen
		assert_equal "012300",   identifier.studyid_intonly_nohyphen
	end

	test "should generate subjectid on creation for any study_subject" do
		identifier = Factory(:identifier)
		assert_not_nil identifier.subjectid
		assert identifier.subjectid.length == 6
	end

	test "should generate patid on creation of case_control_type == 'c'" do
		assert_difference('Patid.next_id', 1) {
			identifier = Factory(:case_identifier).reload
			assert_not_nil identifier.patid
		}
	end

	%w( c b f 4 5 6 ).each do |cct|

		test "should generate childid on creation of case_control_type #{cct}" do
			assert_difference('Childid.next_id', 1) {
				identifier = Factory(:identifier, :case_control_type => cct )
				assert_not_nil identifier.childid
			}
		end

		test "should generate familyid == subjectid on creation of case_control_type #{cct}" do
			identifier = Factory(:identifier, :case_control_type => cct )
			assert_not_nil identifier.subjectid
			assert_not_nil identifier.familyid
			assert_equal   identifier.subjectid, identifier.familyid
		end

	end

	#	TODO "should generate familyid == child's subjectid on creation of mother" do
	test "should generate familyid == child's subjectid on creation of mother" do
		identifier = Factory(:identifier, :case_control_type => 'm' )
		assert_not_nil identifier.subjectid
#	TODO subject could be mother, but child may not be in database?
#		assert_not_nil identifier.familyid
#		assert_equal   identifier.subjectid, identifier.familyid
pending
	end

	test "should generate matchingid == subjectid on creation of case" do
		identifier = Factory(:case_identifier).reload
		assert_not_nil identifier.subjectid
		assert_not_nil identifier.matchingid
		assert_equal   identifier.subjectid, identifier.matchingid
	end

#	%w( b f 4 5 6 ).each do |cct|
#		test "should generate matchingid == case's subjectid on creation of " <<
#				"control case_control_type #{cct}" do
#			identifier = Factory(:identifier, :case_control_type => cct )
##			assert_not_nil identifier.subjectid
##			assert_not_nil identifier.matchingid
##			assert_equal   identifier.subjectid, identifier.familyid
#		end
#	end

	test "should not generate new patid for case if given" do
		#	existing data import
		assert_difference( "Patid.next_id", 0 ) {
		assert_difference( "Patid.count", 0 ) {
		assert_difference( "Identifier.count", 1 ) {
			identifier = Factory.build(:case_identifier)
			identifier.patid = '123'
			identifier.save
			identifier.reload
			assert_equal "0123-C-0", identifier.studyid
			assert_equal "0123C0",   identifier.studyid_nohyphen
			assert_equal "012300",   identifier.studyid_intonly_nohyphen
			assert_equal "0123",     identifier.patid
		} } }
	end

	test "should not generate new childid if given" do
		#	existing data import
		assert_difference( "Childid.next_id", 0 ) {
		assert_difference( "Childid.count", 0 ) {
		assert_difference( "Identifier.count", 1 ) {
			identifier = Factory.build(:case_identifier)
			identifier.childid = '123'
			identifier.save
			identifier.reload
			assert_equal 123, identifier.childid
		} } }
	end

	test "should not generate new orderno if given" do
		#	existing data import
		assert_difference( "Identifier.count", 1 ) {
			identifier = Factory.build(:case_identifier)
			identifier.orderno = 9
			identifier.save
			identifier.reload
			assert_equal 9, identifier.orderno
		}
	end

	test "should not generate new subjectid if given" do
		#	existing data import
		assert_difference( "Identifier.count", 1 ) {
			identifier = Factory.build(:case_identifier)
			identifier.subjectid = "ABCDEF"
			identifier.save
			identifier.reload
			assert_equal "ABCDEF", identifier.subjectid
		}
	end

	test "should not generate new familyid if given" do
		#	existing data import
		assert_difference( "Identifier.count", 1 ) {
			identifier = Factory.build(:case_identifier)
			identifier.familyid = "ABCDEF"
			identifier.save
			identifier.reload
			assert_equal "ABCDEF", identifier.familyid
		}
	end

	test "should not generate new matchingid if given" do
		#	existing data import
		assert_difference( "Identifier.count", 1 ) {
			identifier = Factory.build(:case_identifier)
			identifier.matchingid = "123456"	#	NOTE converted to integer in validation, so make numeric so can compare value
			identifier.save
			identifier.reload
			assert_equal "123456", identifier.matchingid
		}
	end

protected

	def create_identifier(options={})
		identifier = Factory.build(:identifier,options)
		identifier.save
		identifier
	end

end
