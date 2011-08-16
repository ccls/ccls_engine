require 'test_helper'

class Ccls::IdentifierTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_require_attributes( :case_control_type )
#		:case_control_type,
#		:childid,
#		:orderno	)#,
#		:patid )

	assert_should_require_unique_attribute( 
#		:childid,
		:ssn,
#		:subjectid,
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:icf_master_id )
#	assert_should_require_unique_attribute( :patid, 
#		:scope => [:orderno,:case_control_type] )

	assert_should_initially_belong_to( :subject )
	assert_should_not_require_attributes( :study_subject_id )
	assert_should_protect( :study_subject_id )
#	assert_should_require_attributes( :study_subject_id )
#	assert_should_require_unique_attributes( :study_subject_id )
#	assert_should_belong_to( :subject )

	assert_should_not_require_attributes( 
		:ssn,
		:subjectid,
		:lab_no,
		:related_childid,
		:related_case_childid,
		:hospital_no,
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:matchingid,
		:familyid )

	assert_should_require_attribute_length( 
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
#	can't do this with case_control_type as is modified in before_validation
#	which will cause the test to fail and equality test
#		:case_control_type,
		:lab_no,
		:related_childid,
		:related_case_childid,
			:maximum => 250 )

#	can't do this due to before_validation modification
#	assert_should_require_attribute_length :patid, :maximum => 4
	assert_should_require_attribute_length :childidwho, :maximum => 10
	assert_should_require_attribute_length :newid, :maximum => 6
	assert_should_require_attribute_length :gbid, :maximum => 26
	assert_should_require_attribute_length :lab_no_wiemels, :maximum => 25
	assert_should_require_attribute_length :idno_wiemels, :maximum => 10
	assert_should_require_attribute_length :accession_no, :maximum => 25
	assert_should_require_attribute_length :icf_master_id, :maximum => 9

	assert_should_protect_attributes(:studyid,:studyid_nohyphen,:studyid_intonly_nohyphen,
		:familyid, :childid, :subjectid, :patid)	#, :matchingid

#	assert_should_protect_attributes(:subjectid)

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
#	test "should require study_subject_id on update" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			object.reload.update_attributes(:orderno => "New Order No")
#			assert object.errors.on(:subject)
#		end
#	end

	test "should require study_subject_id" do
		assert_difference( "Subject.count", 0 ) {
		assert_difference( "#{model_name}.count", 0 ) {
			object = create_object(:subject => nil)
			assert object.errors.on_attr_and_type(:study_subject_id, :blank)
		} }
	end

	test "should require unique study_subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on_attr_and_type(:study_subject_id,:taken)
		end
	end

#	test "should nullify blank subjectid before validation" do
#		identifier = Factory.build(:identifier, :subjectid => '')
#		assert  identifier.subjectid.blank?
#		assert !identifier.subjectid.nil?
#		identifier.valid?
#		assert  identifier.subjectid.blank?
#		assert  identifier.subjectid.nil?
#	end 

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
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => 987654321)
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string all numeric ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => '987654321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string standard format ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => '987-65-4321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
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
#			assert_difference( "#{model_name}.count", 0 ) do
#				object = create_object(:ssn => invalid_ssn)
#				assert object.errors.on(:ssn)
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

	#	TODO "should NOT generate patid on creation of case_control_type == nil" do
	test "should NOT generate patid on creation of case_control_type == nil" do
#		assert_difference('Patid.next_id', 0) {
#			identifier = Factory(:identifier, :case_control_type => nil )
#			assert_nil identifier.patid
#		}
pending
	end

	test "should NOT generate patid on creation of case_control_type == 'M'" do
		assert_difference('Patid.next_id', 0) {
			identifier = Factory(:identifier, :case_control_type => 'M' )
			assert_nil identifier.patid
		}
	end

#	patid and childid should be protected as they are generated values

	test "should generate orderno = 0 for case_control_type == 'c'" do
		identifier = Factory(:identifier, 
			:case_control_type => 'c').reload
		assert_equal 0, identifier.orderno
	end

	test "should set studyid with patid, case_control_type and orderno for" <<
			" case_control_type c" do
		Identifier.any_instance.stubs(:get_next_patid).returns('123')
		identifier = Factory(:identifier, 
			:case_control_type => 'c'
		).reload
		assert_equal "0123-C-0", identifier.studyid
		assert_equal "0123C0",   identifier.studyid_nohyphen
		assert_equal "012300",   identifier.studyid_intonly_nohyphen
	end

#	test "should set studyid with patid, case_control_type and orderno for" <<
#			" case_control_type 4" do
#		Identifier.any_instance.stubs(:get_next_patid).returns('123')
#		identifier = Factory(:identifier, 
#			:case_control_type => '4',
##			:patid   => '123',
#			:orderno => '4'
#		).reload
#		assert_equal "0123-4-4", identifier.studyid
#		assert_equal "012344",   identifier.studyid_nohyphen
#		assert_equal "012344",   identifier.studyid_intonly_nohyphen
#	end

	test "should generate subjectid on creation for any subject" do
		identifier = Factory(:identifier)
		assert_not_nil identifier.subjectid
		assert identifier.subjectid.length == 6
	end

	test "should generate patid on creation of case_control_type == 'c'" do
		assert_difference('Patid.next_id', 1) {
			identifier = Factory(:identifier, :case_control_type => 'c' )
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
#		assert_not_nil identifier.familyid
#		assert_equal   identifier.subjectid, identifier.familyid
pending
	end

	test "should generate matchingid == subjectid on creation of case" do
		identifier = Factory(:identifier, :case_control_type => 'c')
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
		assert_difference( "#{model_name}.count", 1 ) {
			identifier = Factory.build(:identifier, :case_control_type => 'c')
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
		assert_difference( "#{model_name}.count", 1 ) {
			identifier = Factory.build(:identifier, :case_control_type => 'c')
			identifier.childid = '123'
			identifier.save
			identifier.reload
			assert_equal 123, identifier.childid
		} } }
	end

	test "should not generate new orderno if given" do
		#	existing data import
		assert_difference( "#{model_name}.count", 1 ) {
			identifier = Factory.build(:identifier, :case_control_type => 'c')
			identifier.orderno = 9
			identifier.save
			identifier.reload
			assert_equal 9, identifier.orderno
		}
	end

	test "should not generate new subjectid if given" do
		#	existing data import
		assert_difference( "#{model_name}.count", 1 ) {
			identifier = Factory.build(:identifier, :case_control_type => 'c')
			identifier.subjectid = "ABCDEF"
			identifier.save
			identifier.reload
			assert_equal "ABCDEF", identifier.subjectid
		}
	end

	test "should not generate new familyid if given" do
		#	existing data import
pending
	end

	test "should not generate new matchingid if given" do
		#	existing data import
pending
	end




#	test "should validate on create" do
#		puts "Creating"
#		identifier = Factory(:identifier)
#		puts "Saving again"
#		identifier.save
#Creating
#in prepare_fields_for_validation
#in prepare_fields_for_validation_on_create
#Saving again
#in prepare_fields_for_validation
#	end

#	test "should touch subject after save" do
#		object = create_object
#		assert_not_nil object.subject
#		sleep 2
#		assert_changes("Subject.find(#{object.subject.id}).updated_at") {
#			object.touch
#		}
#	end

#protected
#
#	def create_object(options={})
#		record = Factory.build(:identifier,options)
#		record.attributes=options	#	can't remember why I did this, but doesn't seem needed now?
#		record.save
#		record
#	end

end
