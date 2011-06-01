require 'test_helper'

class Ccls::AbstractTest < ActiveSupport::TestCase
	assert_should_belong_to :subject

	assert_should_protect( :subject_id )
	assert_should_protect( :entry_1_by_uid )
	assert_should_protect( :entry_2_by_uid )
	assert_should_protect( :merged_by_uid )

	assert_should_not_require( :cbc_percent_blasts_unknown )
	assert_should_not_require( :cbc_percent_blasts )
	assert_should_not_require( :response_classification_day_14 )
	assert_should_not_require( :response_classification_day_28 )
	assert_should_not_require( :response_classification_day_7 )
	assert_should_not_require( :response_blasts_units_day_14 )
	assert_should_not_require( :response_blasts_units_day_28 )
	assert_should_not_require( :response_blasts_units_day_7 )
	assert_should_not_require( :marrow_biopsy_diagnosis )
	assert_should_not_require( :marrow_aspirate_diagnosis )
	assert_should_not_require( :csf_white_blood_count_text )
	assert_should_not_require( :csf_red_blood_count_text )
	assert_should_not_require( :blasts_are_present )
	assert_should_not_require( :peripheral_blood_in_csf )
	assert_should_not_require( :csf_comment )
	assert_should_not_require( :chemo_protocol_report_found )
	assert_should_not_require( :chemo_protocol_name )
	assert_should_not_require( :chemo_protocol_agent_description )
	assert_should_not_require( :response_cd10_day_14 )
	assert_should_not_require( :response_cd10_day_7 )
	assert_should_not_require( :response_cd13_day_14 )
	assert_should_not_require( :response_cd13_day_7 )
	assert_should_not_require( :response_cd14_day_14 )
	assert_should_not_require( :response_cd14_day_7 )
	assert_should_not_require( :response_cd15_day_14 )
	assert_should_not_require( :response_cd15_day_7 )
	assert_should_not_require( :response_cd19_day_14 )
	assert_should_not_require( :response_cd19_day_7 )
	assert_should_not_require( :response_cd19cd10_day_14 )
	assert_should_not_require( :response_cd19cd10_day_7 )
	assert_should_not_require( :response_cd1a_day_14 )
	assert_should_not_require( :response_cd2a_day_14 )
	assert_should_not_require( :response_cd20_day_14 )
	assert_should_not_require( :response_cd20_day_7 )
	assert_should_not_require( :response_cd3a_day_14 )
	assert_should_not_require( :response_cd3_day_7 )
	assert_should_not_require( :response_cd33_day_14 )
	assert_should_not_require( :response_cd33_day_7 )
	assert_should_not_require( :response_cd34_day_14 )
	assert_should_not_require( :response_cd34_day_7 )
	assert_should_not_require( :response_cd4a_day_14 )
	assert_should_not_require( :response_cd5a_day_14 )
	assert_should_not_require( :response_cd56_day_14 )
	assert_should_not_require( :response_cd61_day_14 )
	assert_should_not_require( :response_cd7a_day_14 )
	assert_should_not_require( :response_cd8a_day_14 )
	assert_should_not_require( :chest_imaging_report_found )
	assert_should_not_require( :mediastinal_mass_present )
	assert_should_not_require( :chest_imaging_comment )
	assert_should_not_require( :received_chest_ct )
	assert_should_not_require( :chest_ct_taken_on )
	assert_should_not_require( :chest_ct_medmass_present )
	assert_should_not_require( :cytogen_report_found )
	assert_should_not_require( :conventional_karyotype_results )
	assert_should_not_require( :normal_cytogen )
	assert_should_not_require( :is_cytogen_hosp_fish_t1221_done )
	assert_should_not_require( :is_karyotype_normal )
	assert_should_not_require( :cytogen_comment )
	assert_should_not_require( :discharge_summary )
	assert_should_not_require( :diagnosis_is_all )
	assert_should_not_require( :diagnosis_all_type_id )
	assert_should_not_require( :diagnosis_is_cml )
	assert_should_not_require( :diagnosis_is_cll )
	assert_should_not_require( :diagnosis_is_aml )
	assert_should_not_require( :diagnosis_aml_type_id )
	assert_should_not_require( :diagnosis_is_other )
	assert_should_not_require( :flow_cyto_report_found )
	assert_should_not_require( :flow_cyto_cd10 )
	assert_should_not_require( :flow_cyto_igm )
	assert_should_not_require( :flow_cyto_igm_text )
	assert_should_not_require( :flow_cyto_bm_kappa )
	assert_should_not_require( :flow_cyto_bm_kappa_text )
	assert_should_not_require( :flow_cyto_bm_lambda )
	assert_should_not_require( :flow_cyto_bm_lambda_text )
	assert_should_not_require( :flow_cyto_cd10_19 )
	assert_should_not_require( :flow_cyto_cd10_19_text )
	assert_should_not_require( :flow_cyto_cd10_text )
	assert_should_not_require( :flow_cyto_cd19 )
	assert_should_not_require( :flow_cyto_cd19_text )
	assert_should_not_require( :flow_cyto_cd20 )
	assert_should_not_require( :flow_cyto_cd20_text )
	assert_should_not_require( :flow_cyto_cd21 )
	assert_should_not_require( :flow_cyto_cd21_text )
	assert_should_not_require( :flow_cyto_cd22 )
	assert_should_not_require( :flow_cyto_cd22_text )
	assert_should_not_require( :flow_cyto_cd23 )
	assert_should_not_require( :flow_cyto_cd23_text )
	assert_should_not_require( :flow_cyto_cd24 )
	assert_should_not_require( :flow_cyto_cd24_text )
	assert_should_not_require( :flow_cyto_cd40 )
	assert_should_not_require( :flow_cyto_cd40_text )
	assert_should_not_require( :flow_cyto_surface_ig )
	assert_should_not_require( :flow_cyto_surface_ig_text )
	assert_should_not_require( :flow_cyto_cd1a )
	assert_should_not_require( :flow_cyto_cd1a_text )
	assert_should_not_require( :flow_cyto_cd2 )
	assert_should_not_require( :flow_cyto_cd2_text )
	assert_should_not_require( :flow_cyto_cd3 )
	assert_should_not_require( :flow_cyto_cd3_text )
	assert_should_not_require( :flow_cyto_cd4 )
	assert_should_not_require( :flow_cyto_cd4_text )
	assert_should_not_require( :flow_cyto_cd5 )
	assert_should_not_require( :flow_cyto_cd5_text )
	assert_should_not_require( :flow_cyto_cd7 )
	assert_should_not_require( :flow_cyto_cd7_text )
	assert_should_not_require( :flow_cyto_cd8 )
	assert_should_not_require( :flow_cyto_cd8_text )
	assert_should_not_require( :flow_cyto_cd3_cd4 )
	assert_should_not_require( :flow_cyto_cd3_cd4_text )
	assert_should_not_require( :flow_cyto_cd3_cd8 )
	assert_should_not_require( :flow_cyto_cd3_cd8_text )
	assert_should_not_require( :flow_cyto_cd11b )
	assert_should_not_require( :flow_cyto_cd11b_text )
	assert_should_not_require( :flow_cyto_cd11c )
	assert_should_not_require( :flow_cyto_cd11c_text )
	assert_should_not_require( :flow_cyto_cd13 )
	assert_should_not_require( :flow_cyto_cd13_text )
	assert_should_not_require( :flow_cyto_cd15 )
	assert_should_not_require( :flow_cyto_cd15_text )
	assert_should_not_require( :flow_cyto_cd33 )
	assert_should_not_require( :flow_cyto_cd33_text )
	assert_should_not_require( :flow_cyto_cd41 )
	assert_should_not_require( :flow_cyto_cd41_text )
	assert_should_not_require( :flow_cyto_cdw65 )
	assert_should_not_require( :flow_cyto_cdw65_text )
	assert_should_not_require( :flow_cyto_cd34 )
	assert_should_not_require( :flow_cyto_cd34_text )
	assert_should_not_require( :flow_cyto_cd61 )
	assert_should_not_require( :flow_cyto_cd61_text )
	assert_should_not_require( :flow_cyto_cd14 )
	assert_should_not_require( :flow_cyto_cd14_text )
	assert_should_not_require( :flow_cyto_glycoa )
	assert_should_not_require( :flow_cyto_glycoa_text )
	assert_should_not_require( :flow_cyto_cd16 )
	assert_should_not_require( :flow_cyto_cd16_text )
	assert_should_not_require( :flow_cyto_cd56 )
	assert_should_not_require( :flow_cyto_cd56_text )
	assert_should_not_require( :flow_cyto_cd57 )
	assert_should_not_require( :flow_cyto_cd57_text )
	assert_should_not_require( :flow_cyto_cd9 )
	assert_should_not_require( :flow_cyto_cd9_text )
	assert_should_not_require( :flow_cyto_cd25 )
	assert_should_not_require( :flow_cyto_cd25_text )
	assert_should_not_require( :flow_cyto_cd38 )
	assert_should_not_require( :flow_cyto_cd38_text )
	assert_should_not_require( :flow_cyto_cd45 )
	assert_should_not_require( :flow_cyto_cd45_text )
	assert_should_not_require( :flow_cyto_cd71 )
	assert_should_not_require( :flow_cyto_cd71_text )
	assert_should_not_require( :flow_cyto_tdt )
	assert_should_not_require( :flow_cyto_tdt_text )
	assert_should_not_require( :flow_cyto_hladr )
	assert_should_not_require( :flow_cyto_hladr_text )
	assert_should_not_require( :flow_cyto_other_marker_1_name )
	assert_should_not_require( :flow_cyto_other_marker_1 )
	assert_should_not_require( :flow_cyto_other_marker_1_text )
	assert_should_not_require( :flow_cyto_other_marker_2_name )
	assert_should_not_require( :flow_cyto_other_marker_2 )
	assert_should_not_require( :flow_cyto_other_marker_2_text )
	assert_should_not_require( :flow_cyto_other_marker_3_name )
	assert_should_not_require( :flow_cyto_other_marker_3 )
	assert_should_not_require( :flow_cyto_other_marker_3_text )
	assert_should_not_require( :flow_cyto_other_marker_4_name )
	assert_should_not_require( :flow_cyto_other_marker_4 )
	assert_should_not_require( :flow_cyto_other_marker_4_text )
	assert_should_not_require( :flow_cyto_other_marker_5_name )
	assert_should_not_require( :flow_cyto_other_marker_5 )
	assert_should_not_require( :flow_cyto_other_marker_5_text )
	assert_should_not_require( :flow_cyto_remarks )
	assert_should_not_require( :tdt_often_found_flow_cytometry )
	assert_should_not_require( :tdt_report_found )
	assert_should_not_require( :tdt_positive_or_negative )
	assert_should_not_require( :response_comment_day_7 )
	assert_should_not_require( :response_comment_day_14 )
	assert_should_not_require( :hospital_fish_results )
	assert_should_not_require( :ucb_fish_results )
	assert_should_not_require( :response_hladr_day_14 )
	assert_should_not_require( :response_hladr_day_7 )
	assert_should_not_require( :histo_report_found )
	assert_should_not_require( :histo_report_results )
	assert_should_not_require( :response_other1_value_day_14 )
	assert_should_not_require( :response_other1_value_day_7 )
	assert_should_not_require( :response_other2_value_day_14 )
	assert_should_not_require( :response_other2_value_day_7 )
	assert_should_not_require( :response_other3_value_day_14 )
	assert_should_not_require( :response_other4_value_day_14 )
	assert_should_not_require( :response_other5_value_day_14 )
	assert_should_not_require( :h_and_p_reports_found )
	assert_should_not_require( :physical_neuro )
	assert_should_not_require( :physical_other_soft_2 )
	assert_should_not_require( :vital_status_id )
	assert_should_not_require( :physical_gingival )
	assert_should_not_require( :physical_leukemic_skin )
	assert_should_not_require( :physical_lymph )
	assert_should_not_require( :physical_spleen )
	assert_should_not_require( :physical_testicle )
	assert_should_not_require( :physical_other_soft )
	assert_should_not_require( :ploidy_report_found )
	assert_should_not_require( :is_hypodiploid )
	assert_should_not_require( :is_hyperdiploid )
	assert_should_not_require( :is_diploid )
	assert_should_not_require( :dna_index )
	assert_should_not_require( :other_dna_measure )
	assert_should_not_require( :ploidy_comment )
	assert_should_not_require( :response_comment )
	assert_should_not_require( :response_other1_name_day_14 )
	assert_should_not_require( :response_other1_name_day_7 )
	assert_should_not_require( :response_other2_name_day_14 )
	assert_should_not_require( :response_other2_name_day_7 )
	assert_should_not_require( :response_other3_name_day_14 )
	assert_should_not_require( :response_other4_name_day_14 )
	assert_should_not_require( :response_other5_name_day_14 )
	assert_should_not_require( :fab_classification )
	assert_should_not_require( :diagnosis_icdo_description )
	assert_should_not_require( :diagnosis_icdo_number )
	assert_should_not_require( :cytogen_t1221 )
	assert_should_not_require( :cytogen_inv16 )
	assert_should_not_require( :cytogen_t119 )
	assert_should_not_require( :cytogen_t821 )
	assert_should_not_require( :cytogen_t1517 )
	assert_should_not_require( :cytogen_is_hyperdiploidy )
	assert_should_not_require( :cytogen_chromosome_number )
	assert_should_not_require( :cytogen_other_trans_1 )
	assert_should_not_require( :cytogen_other_trans_2 )
	assert_should_not_require( :cytogen_other_trans_3 )
	assert_should_not_require( :cytogen_other_trans_4 )
	assert_should_not_require( :cytogen_other_trans_5 )
	assert_should_not_require( :cytogen_other_trans_6 )
	assert_should_not_require( :cytogen_other_trans_7 )
	assert_should_not_require( :cytogen_other_trans_8 )
	assert_should_not_require( :cytogen_other_trans_9 )
	assert_should_not_require( :cytogen_other_trans_10 )
	assert_should_not_require( :cytogen_t922 )
	assert_should_not_require( :response_fab_subtype )
	assert_should_not_require( :response_tdt_day_14 )
	assert_should_not_require( :response_tdt_day_7 )
	assert_should_not_require( :height_at_diagnosis )
	assert_should_not_require( :weight_at_diagnosis )
	assert_should_not_require( :hyperdiploidy_by )
	assert_should_not_require( :current_user )
	assert_should_not_require( :response_day_7_days_since_treatment_began )
	assert_should_not_require( :response_day_7_days_since_diagnosis )
	assert_should_not_require( :response_day_14_days_since_treatment_began )
	assert_should_not_require( :response_day_14_days_since_diagnosis )
	assert_should_not_require( :response_day_28_days_since_treatment_began )
	assert_should_not_require( :response_day_28_days_since_diagnosis )

	with_options :maximum => 2 do |o|
		o.assert_should_require_length( :response_classification_day_14 )
		o.assert_should_require_length( :response_classification_day_28 )
		o.assert_should_require_length( :response_classification_day_7 )
	end
	with_options :maximum => 3 do |o|
		o.assert_should_require_length( :cytogen_chromosome_number )
	end
	with_options :maximum => 4 do |o|
		o.assert_should_require_length( :flow_cyto_other_marker_1 )
		o.assert_should_require_length( :flow_cyto_other_marker_2 )
		o.assert_should_require_length( :flow_cyto_other_marker_3 )
		o.assert_should_require_length( :flow_cyto_other_marker_4 )
		o.assert_should_require_length( :flow_cyto_other_marker_5 )
		o.assert_should_require_length( :response_other1_value_day_14 )
		o.assert_should_require_length( :response_other1_value_day_7 )
		o.assert_should_require_length( :response_other2_value_day_14 )
		o.assert_should_require_length( :response_other2_value_day_7 )
		o.assert_should_require_length( :response_other3_value_day_14 )
		o.assert_should_require_length( :response_other4_value_day_14 )
		o.assert_should_require_length( :response_other5_value_day_14 )
	end
	with_options :maximum => 5 do |o|
		o.assert_should_require_length( :normal_cytogen )
		o.assert_should_require_length( :is_cytogen_hosp_fish_t1221_done )
		o.assert_should_require_length( :is_karyotype_normal )
		o.assert_should_require_length( :physical_neuro )
		o.assert_should_require_length( :physical_other_soft_2 )
		o.assert_should_require_length( :physical_gingival )
		o.assert_should_require_length( :physical_leukemic_skin )
		o.assert_should_require_length( :physical_lymph )
		o.assert_should_require_length( :physical_spleen )
		o.assert_should_require_length( :physical_testicle )
		o.assert_should_require_length( :physical_other_soft )
		o.assert_should_require_length( :is_hypodiploid )
		o.assert_should_require_length( :is_hyperdiploid )
		o.assert_should_require_length( :is_diploid )
		o.assert_should_require_length( :dna_index )
		o.assert_should_require_length( :cytogen_is_hyperdiploidy )
	end
	with_options :maximum => 9 do |o|
		o.assert_should_require_length( :cytogen_t1221 )
		o.assert_should_require_length( :cytogen_inv16 )
		o.assert_should_require_length( :cytogen_t119 )
		o.assert_should_require_length( :cytogen_t821 )
		o.assert_should_require_length( :cytogen_t1517 )
	end
	with_options :maximum => 10 do |o|
		o.assert_should_require_length( :response_tdt_day_14 )
		o.assert_should_require_length( :response_tdt_day_7 )
		o.assert_should_require_length( :response_cd10_day_14 )
		o.assert_should_require_length( :response_cd10_day_7 )
		o.assert_should_require_length( :response_cd13_day_14 )
		o.assert_should_require_length( :response_cd13_day_7 )
		o.assert_should_require_length( :response_cd14_day_14 )
		o.assert_should_require_length( :response_cd14_day_7 )
		o.assert_should_require_length( :response_cd15_day_14 )
		o.assert_should_require_length( :response_cd15_day_7 )
		o.assert_should_require_length( :response_cd19_day_14 )
		o.assert_should_require_length( :response_cd19_day_7 )
		o.assert_should_require_length( :response_cd19cd10_day_14 )
		o.assert_should_require_length( :response_cd19cd10_day_7 )
		o.assert_should_require_length( :response_cd1a_day_14 )
		o.assert_should_require_length( :response_cd2a_day_14 )
		o.assert_should_require_length( :response_cd20_day_14 )
		o.assert_should_require_length( :response_cd20_day_7 )
		o.assert_should_require_length( :response_cd3a_day_14 )
		o.assert_should_require_length( :response_cd3_day_7 )
		o.assert_should_require_length( :response_cd33_day_14 )
		o.assert_should_require_length( :response_cd33_day_7 )
		o.assert_should_require_length( :response_cd34_day_14 )
		o.assert_should_require_length( :response_cd34_day_7 )
		o.assert_should_require_length( :response_cd4a_day_14 )
		o.assert_should_require_length( :response_cd5a_day_14 )
		o.assert_should_require_length( :response_cd56_day_14 )
		o.assert_should_require_length( :response_cd61_day_14 )
		o.assert_should_require_length( :response_cd7a_day_14 )
		o.assert_should_require_length( :response_cd8a_day_14 )
		o.assert_should_require_length( :flow_cyto_cd10 )
		o.assert_should_require_length( :flow_cyto_igm )
		o.assert_should_require_length( :flow_cyto_bm_kappa )
		o.assert_should_require_length( :flow_cyto_bm_lambda )
		o.assert_should_require_length( :flow_cyto_cd10_19 )
		o.assert_should_require_length( :flow_cyto_cd19 )
		o.assert_should_require_length( :flow_cyto_cd20 )
		o.assert_should_require_length( :flow_cyto_cd21 )
		o.assert_should_require_length( :flow_cyto_cd22 )
		o.assert_should_require_length( :flow_cyto_cd23 )
		o.assert_should_require_length( :flow_cyto_cd24 )
		o.assert_should_require_length( :flow_cyto_cd40 )
		o.assert_should_require_length( :flow_cyto_surface_ig )
		o.assert_should_require_length( :flow_cyto_cd1a )
		o.assert_should_require_length( :flow_cyto_cd2 )
		o.assert_should_require_length( :flow_cyto_cd3 )
		o.assert_should_require_length( :flow_cyto_cd4 )
		o.assert_should_require_length( :flow_cyto_cd5 )
		o.assert_should_require_length( :flow_cyto_cd7 )
		o.assert_should_require_length( :flow_cyto_cd8 )
		o.assert_should_require_length( :flow_cyto_cd3_cd4 )
		o.assert_should_require_length( :flow_cyto_cd3_cd8 )
		o.assert_should_require_length( :flow_cyto_cd11b )
		o.assert_should_require_length( :flow_cyto_cd11c )
		o.assert_should_require_length( :flow_cyto_cd13 )
		o.assert_should_require_length( :flow_cyto_cd15 )
		o.assert_should_require_length( :flow_cyto_cd33 )
		o.assert_should_require_length( :flow_cyto_cd41 )
		o.assert_should_require_length( :flow_cyto_cdw65 )
		o.assert_should_require_length( :flow_cyto_cd34 )
		o.assert_should_require_length( :flow_cyto_cd61 )
		o.assert_should_require_length( :flow_cyto_cd14 )
		o.assert_should_require_length( :flow_cyto_glycoa )
		o.assert_should_require_length( :flow_cyto_cd16 )
		o.assert_should_require_length( :flow_cyto_cd56 )
		o.assert_should_require_length( :flow_cyto_cd57 )
		o.assert_should_require_length( :flow_cyto_cd9 )
		o.assert_should_require_length( :flow_cyto_cd25 )
		o.assert_should_require_length( :flow_cyto_cd38 )
		o.assert_should_require_length( :flow_cyto_cd45 )
		o.assert_should_require_length( :flow_cyto_cd71 )
		o.assert_should_require_length( :flow_cyto_tdt )
		o.assert_should_require_length( :flow_cyto_hladr )
		o.assert_should_require_length( :response_hladr_day_14 )
		o.assert_should_require_length( :response_hladr_day_7 )
	end
	with_options :maximum => 15 do |o|
		o.assert_should_require_length( :response_blasts_units_day_14 )
		o.assert_should_require_length( :response_blasts_units_day_28 )
		o.assert_should_require_length( :response_blasts_units_day_7 )
		o.assert_should_require_length( :other_dna_measure )
		o.assert_should_require_length( :response_fab_subtype )
	end
	with_options :maximum => 20 do |o|
		o.assert_should_require_length( :flow_cyto_other_marker_1_name )
		o.assert_should_require_length( :flow_cyto_other_marker_2_name )
		o.assert_should_require_length( :flow_cyto_other_marker_3_name )
		o.assert_should_require_length( :flow_cyto_other_marker_4_name )
		o.assert_should_require_length( :flow_cyto_other_marker_5_name )
	end
	with_options :maximum => 25 do |o|
		o.assert_should_require_length( :response_other1_name_day_14 )
		o.assert_should_require_length( :response_other1_name_day_7 )
		o.assert_should_require_length( :response_other2_name_day_14 )
		o.assert_should_require_length( :response_other2_name_day_7 )
		o.assert_should_require_length( :response_other3_name_day_14 )
		o.assert_should_require_length( :response_other4_name_day_14 )
		o.assert_should_require_length( :response_other5_name_day_14 )
	end
	with_options :maximum => 35 do |o|
		o.assert_should_require_length( :cytogen_other_trans_1 )
		o.assert_should_require_length( :cytogen_other_trans_2 )
		o.assert_should_require_length( :cytogen_other_trans_3 )
		o.assert_should_require_length( :cytogen_other_trans_4 )
		o.assert_should_require_length( :cytogen_other_trans_5 )
		o.assert_should_require_length( :cytogen_other_trans_6 )
		o.assert_should_require_length( :cytogen_other_trans_7 )
		o.assert_should_require_length( :cytogen_other_trans_8 )
		o.assert_should_require_length( :cytogen_other_trans_9 )
		o.assert_should_require_length( :cytogen_other_trans_10 )
	end
	with_options :maximum => 50 do |o|
		o.assert_should_require_length( :flow_cyto_igm_text )
		o.assert_should_require_length( :flow_cyto_bm_kappa_text )
		o.assert_should_require_length( :flow_cyto_bm_lambda_text )
		o.assert_should_require_length( :flow_cyto_cd10_text )
		o.assert_should_require_length( :flow_cyto_cd19_text )
		o.assert_should_require_length( :flow_cyto_cd10_19_text )
		o.assert_should_require_length( :flow_cyto_cd20_text )
		o.assert_should_require_length( :flow_cyto_cd21_text )
		o.assert_should_require_length( :flow_cyto_cd22_text )
		o.assert_should_require_length( :flow_cyto_cd23_text )
		o.assert_should_require_length( :flow_cyto_cd24_text )
		o.assert_should_require_length( :flow_cyto_cd40_text )
		o.assert_should_require_length( :flow_cyto_surface_ig_text )
		o.assert_should_require_length( :flow_cyto_cd1a_text )
		o.assert_should_require_length( :flow_cyto_cd2_text )
		o.assert_should_require_length( :flow_cyto_cd3_text )
		o.assert_should_require_length( :flow_cyto_cd4_text )
		o.assert_should_require_length( :flow_cyto_cd5_text )
		o.assert_should_require_length( :flow_cyto_cd7_text )
		o.assert_should_require_length( :flow_cyto_cd8_text )
		o.assert_should_require_length( :flow_cyto_cd3_cd4_text )
		o.assert_should_require_length( :flow_cyto_cd3_cd8_text )
		o.assert_should_require_length( :flow_cyto_cd11b_text )
		o.assert_should_require_length( :flow_cyto_cd11c_text )
		o.assert_should_require_length( :flow_cyto_cd13_text )
		o.assert_should_require_length( :flow_cyto_cd15_text )
		o.assert_should_require_length( :flow_cyto_cd33_text )
		o.assert_should_require_length( :flow_cyto_cd41_text )
		o.assert_should_require_length( :flow_cyto_cdw65_text )
		o.assert_should_require_length( :flow_cyto_cd34_text )
		o.assert_should_require_length( :flow_cyto_cd61_text )
		o.assert_should_require_length( :flow_cyto_cd14_text )
		o.assert_should_require_length( :flow_cyto_glycoa_text )
		o.assert_should_require_length( :flow_cyto_cd16_text )
		o.assert_should_require_length( :flow_cyto_cd56_text )
		o.assert_should_require_length( :flow_cyto_cd57_text )
		o.assert_should_require_length( :flow_cyto_cd9_text )
		o.assert_should_require_length( :flow_cyto_cd25_text )
		o.assert_should_require_length( :flow_cyto_cd38_text )
		o.assert_should_require_length( :flow_cyto_cd45_text )
		o.assert_should_require_length( :flow_cyto_cd71_text )
		o.assert_should_require_length( :flow_cyto_tdt_text )
		o.assert_should_require_length( :flow_cyto_hladr_text )
		o.assert_should_require_length( :flow_cyto_other_marker_1_text )
		o.assert_should_require_length( :flow_cyto_other_marker_2_text )
		o.assert_should_require_length( :flow_cyto_other_marker_3_text )
		o.assert_should_require_length( :flow_cyto_other_marker_4_text )
		o.assert_should_require_length( :flow_cyto_other_marker_5_text )
		o.assert_should_require_length( :ucb_fish_results )
		o.assert_should_require_length( :fab_classification )
		o.assert_should_require_length( :diagnosis_icdo_number )
		o.assert_should_require_length( :cytogen_t922 )
	end
	with_options :maximum => 55 do |o|
		o.assert_should_require_length( :diagnosis_icdo_description )
	end
	with_options :maximum => 100 do |o|
		o.assert_should_require_length( :ploidy_comment )
	end
	with_options :maximum => 250 do |o|
		o.assert_should_require_length( :csf_red_blood_count_text )
		o.assert_should_require_length( :blasts_are_present )
		o.assert_should_require_length( :peripheral_blood_in_csf )
		o.assert_should_require_length( :chemo_protocol_name )
		o.assert_should_require_length( :conventional_karyotype_results )
		o.assert_should_require_length( :hospital_fish_results )
		o.assert_should_require_length( :hyperdiploidy_by )
	end
	with_options :maximum => 65000 do |o|
		o.assert_should_require_length( :marrow_biopsy_diagnosis )
		o.assert_should_require_length( :marrow_aspirate_diagnosis )
		o.assert_should_require_length( :csf_white_blood_count_text )
		o.assert_should_require_length( :csf_comment )
		o.assert_should_require_length( :chemo_protocol_agent_description )
		o.assert_should_require_length( :chest_imaging_comment )
		o.assert_should_require_length( :cytogen_comment )
		o.assert_should_require_length( :discharge_summary )
		o.assert_should_require_length( :flow_cyto_remarks )
		o.assert_should_require_length( :response_comment_day_7 )
		o.assert_should_require_length( :response_comment_day_14 )
		o.assert_should_require_length( :histo_report_results )
		o.assert_should_require_length( :response_comment )
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
#				"created_at", "updated_at", "subject_id"]
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
		abstract = Factory(:abstract,:diagnosed_on => Chronic.parse('10 days ago'),
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
		abstract = Factory(:abstract,:diagnosed_on => Chronic.parse('40 days ago'),
			:response_report_on_day_7  => Chronic.parse('30 days ago'),
			:response_report_on_day_14 => Chronic.parse('20 days ago'),
			:response_report_on_day_28 => Chronic.parse('10 days ago')
		)
		assert_not_nil abstract.diagnosed_on
		assert_not_nil abstract.response_day_7_days_since_diagnosis
		assert_equal 10, abstract.response_day_7_days_since_diagnosis
		assert_not_nil abstract.response_day_14_days_since_diagnosis
		assert_equal 20, abstract.response_day_14_days_since_diagnosis
		assert_not_nil abstract.response_day_28_days_since_diagnosis
		assert_equal 30, abstract.response_day_28_days_since_diagnosis
	end

	test "should NOT set days since treatment_began fields on create without treatment_began_on" do
		abstract = Factory(:abstract)
		assert_nil abstract.treatment_began_on
		assert_nil abstract.response_day_7_days_since_treatment_began
		assert_nil abstract.response_day_14_days_since_treatment_began
		assert_nil abstract.response_day_28_days_since_treatment_began
	end

	test "should NOT set days since treatment_began fields on create without response_report_on" do
		abstract = Factory(:abstract,:treatment_began_on => Chronic.parse('10 days ago'),
			:response_report_on_day_7  => nil,
			:response_report_on_day_14 => nil,
			:response_report_on_day_28 => nil
		)
		assert_not_nil abstract.treatment_began_on
		assert_nil abstract.response_day_7_days_since_treatment_began
		assert_nil abstract.response_day_14_days_since_treatment_began
		assert_nil abstract.response_day_28_days_since_treatment_began
	end

	test "should set days since treatment_began fields on create with treatment_began_on" do
		abstract = Factory(:abstract,:treatment_began_on => Chronic.parse('40 days ago'),
			:response_report_on_day_7  => Chronic.parse('30 days ago'),
			:response_report_on_day_14 => Chronic.parse('20 days ago'),
			:response_report_on_day_28 => Chronic.parse('10 days ago')
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

	test "should create first abstract for subject with current_user" do
		assert_difference('Identifier.count',1) {
		assert_difference('Subject.count',1) {
			@subject = create_case_subject_with_patid(1234)
			assert_equal '1234', @subject.patid
		} }
		@current_user = Factory(:user)
		assert_difference('Abstract.count',1) {
			abstract = create_abstract(:current_user => @current_user,
				:subject => @subject)
			assert_equal abstract.entry_1_by, @current_user
			assert_equal abstract.entry_2_by, @current_user
			assert_equal abstract.subject, @subject
		}
	end

	test "should create second abstract for subject with current_user" do
		assert_difference('Identifier.count',1) {
		assert_difference('Subject.count',1) {
			@subject = create_case_subject_with_patid(1234)
			assert_equal '1234', @subject.patid
		} }
		@current_user = Factory(:user)
		abstract = create_abstract(:current_user => @current_user,
			:subject => @subject)
		assert_difference('Abstract.count',1) {
			abstract = create_abstract(:current_user => @current_user,
				:subject => @subject.reload)
			assert_equal abstract.entry_1_by, @current_user
			assert_equal abstract.entry_2_by, @current_user
			assert_equal abstract.subject, @subject
		}
	end

	test "should NOT create third abstract for subject with current_user " <<
			"without merging flag" do
		assert_difference('Identifier.count',1) {
		assert_difference('Subject.count',1) {
			@subject = create_case_subject_with_patid(1234)
			assert_equal '1234', @subject.patid
		} }
		@current_user = Factory(:user)
		abstract = create_abstract(:current_user => @current_user,
			:subject => @subject)
		abstract = create_abstract(:current_user => @current_user,
			:subject => @subject.reload)
		assert_difference('Abstract.count',0) {
			abstract = create_abstract(:current_user => @current_user,
				:subject => @subject.reload)
			assert abstract.errors.on(:subject_id)
		}
	end

	test "should create third abstract for subject with current_user " <<
			"with merging flag" do
		assert_difference('Identifier.count',1) {
		assert_difference('Subject.count',1) {
			@subject = create_case_subject_with_patid(1234)
			assert_equal '1234', @subject.patid
		} }
		@current_user = Factory(:user)
		abstract = create_abstract(:current_user => @current_user,
			:subject => @subject)
		abstract = create_abstract(:current_user => @current_user,
			:subject => @subject.reload)
#	yes, when creating the merged, the other 2 go away
		assert_difference('Abstract.count',-1) {
			abstract = create_abstract(:current_user => @current_user,
				:subject => @subject.reload, :merging => true)
			assert_equal abstract.merged_by, @current_user
			assert_equal abstract.subject, @subject
		}
	end

	test "should NOT create merged abstract if subject already has one" do
		subject = create_case_subject_with_patid(1234)
		a1 = create_abstract(:subject => subject)
		a1.merged_by = Factory(:user)
		a1.save
		assert_not_nil subject.reload.merged_abstract
		assert_not_nil a1.reload.merged_by
		assert a1.merged?
		assert_difference('Abstract.count',0) {
			a2 = create_abstract( :subject => subject, :merging => true)
			assert a2.errors.on(:subject_id)
		}
	end

	test "should return abstract sections" do
		assert !Abstract.class_variable_defined?("@@sections")
		sections = Abstract.sections
		assert  Abstract.class_variable_defined?("@@sections")
		assert sections.is_a?(Array)
		assert sections.length >= 15
	end

end
