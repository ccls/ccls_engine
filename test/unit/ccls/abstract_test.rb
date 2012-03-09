require 'test_helper'

class Ccls::AbstractTest < ActiveSupport::TestCase

	assert_should_belong_to :study_subject
	assert_should_protect( :study_subject_id, :study_subject, :entry_1_by_uid, 
		:entry_2_by_uid, :merged_by_uid )
	assert_should_not_require( *Abstract.db_fields )

	assert_should_require_length( 
		:response_classification_day_7, 
		:response_classification_day_14,
		:response_classification_day_28,
			:maximum => 2 )

	assert_should_require_length( 
		:cytogen_chromosome_number, 
			:maximum => 3 )

	assert_should_require_length( 
		:flow_cyto_other_marker_1,
		:flow_cyto_other_marker_2,
		:flow_cyto_other_marker_3,
		:flow_cyto_other_marker_4,
		:flow_cyto_other_marker_5,
		:response_other1_value_day_7,
		:response_other1_value_day_14,
		:response_other2_value_day_7,
		:response_other2_value_day_14,
		:response_other3_value_day_14,
		:response_other4_value_day_14,
		:response_other5_value_day_14, 
			:maximum => 4 )

	assert_should_require_length( 
		:normal_cytogen,
		:is_cytogen_hosp_fish_t1221_done,
		:is_karyotype_normal,
		:physical_neuro,
		:physical_other_soft_2,
		:physical_gingival,
		:physical_leukemic_skin,
		:physical_lymph,
		:physical_spleen,
		:physical_testicle,
		:physical_other_soft,
		:is_hypodiploid,
		:is_hyperdiploid,
		:is_diploid,
		:dna_index,
		:cytogen_is_hyperdiploidy,
			:maximum => 5 )

	assert_should_require_length( 
		:cytogen_t1221,
		:cytogen_inv16,
		:cytogen_t119,
		:cytogen_t821,
		:cytogen_t1517,
			:maximum => 9 )

	assert_should_require_length( 
		:response_tdt_day_7,
		:response_tdt_day_14,
		:response_cd10_day_7,
		:response_cd10_day_14,
		:response_cd13_day_7,
		:response_cd13_day_14,
		:response_cd14_day_7,
		:response_cd14_day_14,
		:response_cd15_day_7,
		:response_cd15_day_14,
		:response_cd19_day_7,
		:response_cd19_day_14,
		:response_cd19cd10_day_7,
		:response_cd19cd10_day_14,
		:response_cd1a_day_14,
		:response_cd2a_day_14,
		:response_cd20_day_7,
		:response_cd20_day_14,
		:response_cd3_day_7,
		:response_cd3a_day_14,
		:response_cd33_day_7,
		:response_cd33_day_14,
		:response_cd34_day_7,
		:response_cd34_day_14,
		:response_cd4a_day_14,
		:response_cd5a_day_14,
		:response_cd56_day_14,
		:response_cd61_day_14,
		:response_cd7a_day_14,
		:response_cd8a_day_14,
		:flow_cyto_cd10,
		:flow_cyto_igm,
		:flow_cyto_bm_kappa,
		:flow_cyto_bm_lambda,
		:flow_cyto_cd10_19,
		:flow_cyto_cd19,
		:flow_cyto_cd20,
		:flow_cyto_cd21,
		:flow_cyto_cd22,
		:flow_cyto_cd23,
		:flow_cyto_cd24,
		:flow_cyto_cd40,
		:flow_cyto_surface_ig,
		:flow_cyto_cd1a,
		:flow_cyto_cd2,
		:flow_cyto_cd3,
		:flow_cyto_cd3_cd4,
		:flow_cyto_cd3_cd8,
		:flow_cyto_cd4,
		:flow_cyto_cd5,
		:flow_cyto_cd7,
		:flow_cyto_cd8,
		:flow_cyto_cd11b,
		:flow_cyto_cd11c,
		:flow_cyto_cd13,
		:flow_cyto_cd15,
		:flow_cyto_cd33,
		:flow_cyto_cd41,
		:flow_cyto_cdw65,
		:flow_cyto_cd34,
		:flow_cyto_cd61,
		:flow_cyto_cd14,
		:flow_cyto_glycoa,
		:flow_cyto_cd16,
		:flow_cyto_cd56,
		:flow_cyto_cd57,
		:flow_cyto_cd9,
		:flow_cyto_cd25,
		:flow_cyto_cd38,
		:flow_cyto_cd45,
		:flow_cyto_cd71,
		:flow_cyto_tdt,
		:flow_cyto_hladr,
		:response_hladr_day_7,
		:response_hladr_day_14,
			:maximum => 10 )

	assert_should_require_length( 
		:response_blasts_units_day_7,
		:response_blasts_units_day_14,
		:response_blasts_units_day_28,
		:other_dna_measure,
		:response_fab_subtype,
			:maximum => 15 )

	assert_should_require_length( 
		:flow_cyto_other_marker_1_name,
		:flow_cyto_other_marker_2_name,
		:flow_cyto_other_marker_3_name,
		:flow_cyto_other_marker_4_name,
		:flow_cyto_other_marker_5_name,
			:maximum => 20 )

	assert_should_require_length( 
		:response_other1_name_day_7,
		:response_other1_name_day_14,
		:response_other2_name_day_7,
		:response_other2_name_day_14,
		:response_other3_name_day_14,
		:response_other4_name_day_14,
		:response_other5_name_day_14,
			:maximum => 25 )

	assert_should_require_length( 
		:cytogen_other_trans_1,
		:cytogen_other_trans_2,
		:cytogen_other_trans_3,
		:cytogen_other_trans_4,
		:cytogen_other_trans_5,
		:cytogen_other_trans_6,
		:cytogen_other_trans_7,
		:cytogen_other_trans_8,
		:cytogen_other_trans_9,
		:cytogen_other_trans_10,
			:maximum => 35 )

	assert_should_require_length( 
		:flow_cyto_igm_text,
		:flow_cyto_bm_kappa_text,
		:flow_cyto_bm_lambda_text,
		:flow_cyto_cd10_text,
		:flow_cyto_cd19_text,
		:flow_cyto_cd10_19_text,
		:flow_cyto_cd20_text,
		:flow_cyto_cd21_text,
		:flow_cyto_cd22_text,
		:flow_cyto_cd23_text,
		:flow_cyto_cd24_text,
		:flow_cyto_cd40_text,
		:flow_cyto_surface_ig_text,
		:flow_cyto_cd1a_text,
		:flow_cyto_cd2_text,
		:flow_cyto_cd3_text,
		:flow_cyto_cd4_text,
		:flow_cyto_cd5_text,
		:flow_cyto_cd7_text,
		:flow_cyto_cd8_text,
		:flow_cyto_cd3_cd4_text,
		:flow_cyto_cd3_cd8_text,
		:flow_cyto_cd11b_text,
		:flow_cyto_cd11c_text,
		:flow_cyto_cd13_text,
		:flow_cyto_cd15_text,
		:flow_cyto_cd33_text,
		:flow_cyto_cd41_text,
		:flow_cyto_cdw65_text,
		:flow_cyto_cd34_text,
		:flow_cyto_cd61_text,
		:flow_cyto_cd14_text,
		:flow_cyto_glycoa_text,
		:flow_cyto_cd16_text,
		:flow_cyto_cd56_text,
		:flow_cyto_cd57_text,
		:flow_cyto_cd9_text,
		:flow_cyto_cd25_text,
		:flow_cyto_cd38_text,
		:flow_cyto_cd45_text,
		:flow_cyto_cd71_text,
		:flow_cyto_tdt_text,
		:flow_cyto_hladr_text,
		:flow_cyto_other_marker_1_text,
		:flow_cyto_other_marker_2_text,
		:flow_cyto_other_marker_3_text,
		:flow_cyto_other_marker_4_text,
		:flow_cyto_other_marker_5_text,
		:ucb_fish_results,
		:fab_classification,
		:diagnosis_icdo_number,
		:cytogen_t922,
			:maximum => 50 )

	assert_should_require_length( 
		:diagnosis_icdo_description, 
			:maximum => 55 )

	assert_should_require_length( 
		:ploidy_comment, 
			:maximum => 100 )

	assert_should_require_length( 
		:csf_red_blood_count_text,
		:blasts_are_present,
		:peripheral_blood_in_csf,
		:chemo_protocol_name,
		:conventional_karyotype_results,
		:hospital_fish_results,
		:hyperdiploidy_by,
			:maximum => 250 )

	assert_should_require_length( 
		:marrow_biopsy_diagnosis,
		:marrow_aspirate_diagnosis,
		:csf_white_blood_count_text,
		:csf_comment,
		:chemo_protocol_agent_description,
		:chest_imaging_comment,
		:cytogen_comment,
		:discharge_summary,
		:flow_cyto_remarks,
		:response_comment_day_7,
		:response_comment_day_14,
		:histo_report_results,
		:response_comment,
			:maximum => 65000 )

	test "explicit Factory abstract test" do
		assert_difference('Abstract.count',1) {
			@abstract = Factory(:abstract)
		}
		( not_nil = %w( id created_at updated_at cbc_percent_blasts_unknown ) ).each do |c|
			assert_not_nil @abstract.send(c), "#{c} is nil"
		end
		( Abstract.column_names - not_nil ).each do |c|
			assert_nil @abstract.send(c), "#{c} is not nil"
		end
	end

	test "explicit Factory complete_abstract test" do
		assert_difference('Abstract.count',1) {
			#	this factory randomly sets values, some of which can be nil
			abstract = Factory(:complete_abstract)
		}
	end

	test "should not convert weight if weight_units is null" do
		abstract = Factory(:abstract,:weight_at_diagnosis => 100)
		assert_equal 100, abstract.reload.weight_at_diagnosis
	end

	test "should not convert weight if weight_units is kg" do
		abstract = Factory(:abstract,:weight_at_diagnosis => 100, :weight_units => 'kg')
		assert_equal 100, abstract.reload.weight_at_diagnosis
	end

	test "should convert weight to kg if weight_units is lb" do
		abstract = Factory(:abstract,:weight_at_diagnosis => 100, :weight_units => 'lb')
		abstract.reload
		assert_nil       abstract.weight_units
		assert_not_equal 100,   abstract.weight_at_diagnosis
		assert_in_delta   45.3, abstract.weight_at_diagnosis, 0.1
	end

	test "should not convert height if height_units is null" do
		abstract = Factory(:abstract,:height_at_diagnosis => 100)
		assert_equal 100, abstract.reload.height_at_diagnosis
	end

	test "should not convert height if height_units is cm" do
		abstract = Factory(:abstract,:height_at_diagnosis => 100, :height_units => 'cm')
		assert_equal 100, abstract.reload.height_at_diagnosis
	end

	test "should convert height to cm if height_units is in" do
		abstract = Factory(:abstract,:height_at_diagnosis => 100, :height_units => 'in')
		abstract.reload
		assert_nil       abstract.height_units
		assert_not_equal 100, abstract.height_at_diagnosis
		assert_in_delta  254, abstract.height_at_diagnosis, 0.1
	end

#	test "should return an array of ignorable columns" do
#		abstract = Factory(:abstract)
#		assert_equal abstract.ignorable_columns,
#			["id", "entry_1_by_uid", "entry_2_by_uid", "merged_by_uid", 
#				"created_at", "updated_at", "study_subject_id"]
#	end
#
#	test "should return hash of comparable attributes" do
#		abstract = Factory(:abstract)
#		assert abstract.comparable_attributes.is_a?(Hash)
#	end

	test "should return true if abstracts are the same" do
		abstract1 = Factory(:abstract)
		abstract2 = Factory(:abstract)
		assert abstract1.is_the_same_as?(abstract2)
	end

	test "should return false if abstracts are not the same" do
		abstract1 = Factory(:abstract)
		abstract2 = Factory(:abstract, :height_at_diagnosis => 100 )
		assert !abstract1.is_the_same_as?(abstract2)
	end

	test "should return empty hash if abstracts are the same" do
		abstract1 = Factory(:abstract)
		abstract2 = Factory(:abstract)
		assert_equal Hash.new, abstract1.diff(abstract2)
		assert       abstract1.diff(abstract2).empty?
	end

	test "should return hash if abstracts are not the same" do
		abstract1 = Factory(:abstract)
		abstract2 = Factory(:abstract, :height_at_diagnosis => 100 )
		assert !abstract1.diff(abstract2).empty?
		assert  abstract1.diff(abstract2).has_key?('height_at_diagnosis')
	end

	test "should NOT set days since diagnosis fields on create without diagnosed_on" do
		abstract = Factory(:abstract)
		assert_nil abstract.diagnosed_on
		assert_nil abstract.response_day_7_days_since_diagnosis
		assert_nil abstract.response_day_14_days_since_diagnosis
		assert_nil abstract.response_day_28_days_since_diagnosis
	end

	test "should NOT set days since diagnosis fields on create without response_report_on" do
		abstract = Factory(:abstract,
			:diagnosed_on              => ( Date.today - 10 ),
			:response_report_on_day_7  => nil,
			:response_report_on_day_14 => nil,
			:response_report_on_day_28 => nil
		)
		assert_not_nil abstract.diagnosed_on
		assert_nil abstract.response_day_7_days_since_diagnosis
		assert_nil abstract.response_day_14_days_since_diagnosis
		assert_nil abstract.response_day_28_days_since_diagnosis
	end

	test "should set days since diagnosis fields on create with diagnosed_on" do
		today = Date.today
		abstract = Factory(:abstract,
			:diagnosed_on              => ( today - 40 ),
			:response_report_on_day_7  => ( today - 30 ),
			:response_report_on_day_14 => ( today - 20 ),
			:response_report_on_day_28 => ( today - 10 )
		)
		assert_not_nil abstract.diagnosed_on
		assert_not_nil abstract.response_day_7_days_since_diagnosis
		assert_equal 10, abstract.response_day_7_days_since_diagnosis
		assert_not_nil abstract.response_day_14_days_since_diagnosis
		assert_equal 20, abstract.response_day_14_days_since_diagnosis
		assert_not_nil abstract.response_day_28_days_since_diagnosis
		assert_equal 30, abstract.response_day_28_days_since_diagnosis
	end

	test "should NOT set days since treatment_began fields on create" <<
			" without treatment_began_on" do
		abstract = Factory(:abstract)
		assert_nil abstract.treatment_began_on
		assert_nil abstract.response_day_7_days_since_treatment_began
		assert_nil abstract.response_day_14_days_since_treatment_began
		assert_nil abstract.response_day_28_days_since_treatment_began
	end

	test "should NOT set days since treatment_began fields on create" <<
			" without response_report_on" do
		abstract = Factory(:abstract,
			:treatment_began_on        => ( Date.today - 10 ),
			:response_report_on_day_7  => nil,
			:response_report_on_day_14 => nil,
			:response_report_on_day_28 => nil
		)
		assert_not_nil abstract.treatment_began_on
		assert_nil abstract.response_day_7_days_since_treatment_began
		assert_nil abstract.response_day_14_days_since_treatment_began
		assert_nil abstract.response_day_28_days_since_treatment_began
	end

	test "should set days since treatment_began fields on create" <<
			" with treatment_began_on" do
		today = Date.today	
		abstract = Factory(:abstract,
			:treatment_began_on        => ( today - 40 ),
			:response_report_on_day_7  => ( today - 30 ),
			:response_report_on_day_14 => ( today - 20 ),
			:response_report_on_day_28 => ( today - 10 )
		)
		assert_not_nil abstract.treatment_began_on
		assert_not_nil abstract.response_day_7_days_since_treatment_began
		assert_equal 10, abstract.response_day_7_days_since_treatment_began
		assert_not_nil abstract.response_day_14_days_since_treatment_began
		assert_equal 20, abstract.response_day_14_days_since_treatment_began
		assert_not_nil abstract.response_day_28_days_since_treatment_began
		assert_equal 30, abstract.response_day_28_days_since_treatment_began
	end

	test "should save a User as entry_1_by" do
		assert_difference('User.count',1) {
		assert_difference('Abstract.count',1) {
			abstract = Factory(:abstract,:entry_1_by => Factory(:user))
			assert abstract.entry_1_by.is_a?(User)
		} }
	end

	test "should save a User as entry_2_by" do
		assert_difference('User.count',1) {
		assert_difference('Abstract.count',1) {
			abstract = Factory(:abstract,:entry_2_by => Factory(:user))
			assert abstract.entry_2_by.is_a?(User)
		} }
	end

	test "should save a User as merged_by" do
		assert_difference('User.count',1) {
		assert_difference('Abstract.count',1) {
			abstract = Factory(:abstract,:merged_by => Factory(:user))
			assert abstract.merged_by.is_a?(User)
		} }
	end

	test "should create first abstract for study_subject with current_user" do
		assert_difference('StudySubject.count',1) {
			@study_subject = create_case_study_subject_with_patid(1234)
			assert_equal '1234', @study_subject.patid
		}
		@current_user = Factory(:user)
		assert_difference('Abstract.count',1) {
			abstract = create_abstract(:current_user => @current_user,
				:study_subject => @study_subject)
			assert_equal abstract.entry_1_by, @current_user
			assert_equal abstract.entry_2_by, @current_user
			assert_equal abstract.study_subject, @study_subject
		}
	end

	test "should create second abstract for study_subject with current_user" do
		assert_difference('StudySubject.count',1) {
			@study_subject = create_case_study_subject_with_patid(1234)
			assert_equal '1234', @study_subject.patid
		}
		@current_user = Factory(:user)
		abstract = create_abstract(:current_user => @current_user,
			:study_subject => @study_subject)
		assert_difference('Abstract.count',1) {
			abstract = create_abstract(:current_user => @current_user,
				:study_subject => @study_subject.reload)
			assert_equal abstract.entry_1_by, @current_user
			assert_equal abstract.entry_2_by, @current_user
			assert_equal abstract.study_subject, @study_subject
		}
	end

	test "should NOT create third abstract for study_subject with current_user " <<
			"without merging flag" do
		assert_difference('StudySubject.count',1) {
			@study_subject = create_case_study_subject_with_patid(1234)
			assert_equal '1234', @study_subject.patid
		}
		@current_user = Factory(:user)
		abstract = create_abstract(:current_user => @current_user,
			:study_subject => @study_subject)
		abstract = create_abstract(:current_user => @current_user,
			:study_subject => @study_subject.reload)
		assert_difference('Abstract.count',0) {
			abstract = create_abstract(:current_user => @current_user,
				:study_subject => @study_subject.reload)
			assert abstract.errors.on(:study_subject_id)
		}
	end

	test "should create third abstract for study_subject with current_user " <<
			"with merging flag" do
		assert_difference('StudySubject.count',1) {
			@study_subject = create_case_study_subject_with_patid(1234)
			assert_equal '1234', @study_subject.patid
		}
		@current_user = Factory(:user)
		abstract = create_abstract(:current_user => @current_user,
			:study_subject => @study_subject)
		abstract = create_abstract(:current_user => @current_user,
			:study_subject => @study_subject.reload)
#	yes, when creating the merged, the other 2 go away
		assert_difference('Abstract.count',-1) {
			abstract = create_abstract(:current_user => @current_user,
				:study_subject => @study_subject.reload, :merging => true)
			assert_equal abstract.merged_by, @current_user
			assert_equal abstract.study_subject, @study_subject
		}
	end

	test "should NOT create merged abstract if study_subject already has one" do
		study_subject = create_case_study_subject_with_patid(1234)
		a1 = create_abstract(:study_subject => study_subject)
		a1.merged_by = Factory(:user)
		a1.save
		assert_not_nil study_subject.reload.merged_abstract
		assert_not_nil a1.reload.merged_by
		assert a1.merged?
		assert_difference('Abstract.count',0) {
			a2 = create_abstract( :study_subject => study_subject, :merging => true)
			assert a2.errors.on(:study_subject_id)
		}
	end

	test "should return abstract sections for class" do
		sections = Abstract.sections
		assert  Abstract.class_variable_defined?("@@sections")
		assert sections.is_a?(Array)
		assert sections.length >= 15
		assert sections.first.is_a?(Hash)
	end

	test "should return abstract fields for class" do
		fields = Abstract.fields
		assert  Abstract.class_variable_defined?("@@fields")
		assert fields.is_a?(Array)
		assert fields.length >= 15
		assert fields.first.is_a?(Hash)
	end

	test "should return abstract fields for instance" do
		fields = Abstract.new.fields
		assert  Abstract.class_variable_defined?("@@fields")
		assert fields.is_a?(Array)
		assert fields.length >= 15
		assert fields.first.is_a?(Hash)
	end

	test "should return abstract db_fields for class" do
		db_fields = Abstract.db_fields
		assert  Abstract.class_variable_defined?("@@fields")
		assert db_fields.is_a?(Array)
		assert db_fields.length >= 15
		assert db_fields.first.is_a?(String)
	end

	test "should return abstract db_fields for instance" do
		db_fields = Abstract.new.db_fields
		assert  Abstract.class_variable_defined?("@@fields")
		assert db_fields.is_a?(Array)
		assert db_fields.length >= 15
		assert db_fields.first.is_a?(String)
	end

	[ :cbc_report_found,
		:cerebrospinal_fluid_report_found,
		:chemo_protocol_report_found,
		:chest_ct_medmass_present,
		:chest_imaging_report_found,
		:cytogen_hospital_fish_done,
		:cytogen_karyotype_done,
		:cytogen_report_found,
		:cytogen_trisomy4,
		:cytogen_trisomy5,
		:cytogen_trisomy10,
		:cytogen_trisomy17,
		:cytogen_trisomy21,
		:cytogen_ucb_fish_done,
		:diagnosis_is_all,
		:diagnosis_is_aml,
		:diagnosis_is_b_all,
		:diagnosis_is_cll,
		:diagnosis_is_cml,
		:diagnosis_is_other,
		:diagnosis_is_t_all,
		:discharge_summary_found,
		:flow_cyto_num_results_available,
		:flow_cyto_report_found,
		:h_and_p_reports_found,
		:hepatomegaly_present,
		:histo_report_found,
		:is_down_syndrome_phenotype,
		:marrow_aspirate_report_found,
		:marrow_biopsy_report_found,
		:mediastinal_mass_present,
		:patient_on_chemo_protocol,
		:ploidy_report_found,
		:received_bone_marrow_aspirate,
		:received_bone_marrow_biopsy,
		:received_cbc,
		:received_chemo_protocol,
		:received_chest_ct,
		:received_chest_xray,
		:received_csf,
		:received_cytogenetics,
		:received_discharge_summary,
		:received_flow_cytometry,
		:received_hla_typing,
		:received_h_and_p,
		:received_other_reports,
		:received_ploidy,
		:received_resp_to_therapy,
		:response_day14or28_flag,
		:response_day30_is_in_remission,
		:response_is_inconclusive_day_7,
		:response_is_inconclusive_day_14,
		:response_is_inconclusive_day_21,
		:response_is_inconclusive_day_28,
		:response_report_found_day_7,
		:response_report_found_day_14,
		:response_report_found_day_28,
		:splenomegaly_present,
		:tdt_often_found_flow_cytometry,
		:tdt_report_found ].each do |field|

		#	Making assumption that 12345 will NEVER be a valid value.
		test "should NOT allow 12345 for #{field}" do
			abstract = Abstract.new(field => 12345)
			abstract.valid?
			assert abstract.errors.on_attr_and_type?(field,:inclusion)
		end

		test "should allow nil for #{field}" do
			abstract = Abstract.new(field => nil)
			assert_nil abstract.send(field)
			abstract.valid?
			assert !abstract.errors.on(field)
		end

		test "should allow all valid YNDK values for #{field}" do
			abstract = Abstract.new
			YNDK.valid_values.each do |value|
				abstract.send("#{field}=", value)
				abstract.valid?
				assert !abstract.errors.on(field)
			end
		end

	end

end
