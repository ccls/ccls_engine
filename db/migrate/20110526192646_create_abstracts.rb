class CreateAbstracts < SharedMigration
	def self.up
		create_table :abstracts do |t|
			t.integer  :study_subject_id							#, :null => false
			t.integer  :response_day14or28_flag
			t.integer  :received_bone_marrow_biopsy
			t.integer  :received_h_and_p
			t.integer  :received_other_reports
			t.integer  :received_discharge_summary
#			t.integer  :received_other_reports
			t.integer  :received_chemo_protocol
			t.integer  :received_resp_to_therapy
			t.text     :received_specify_other_reports
			t.integer  :received_bone_marrow_aspirate
			t.integer  :received_flow_cytometry
			t.integer  :received_ploidy
			t.integer  :received_hla_typing
			t.integer  :received_cytogenetics
			t.integer  :received_cbc
			t.integer  :received_csf
			t.integer  :received_chest_xray
			t.integer  :response_report_found_day_14
			t.integer  :response_report_found_day_28
			t.integer  :response_report_found_day_7
			t.date     :response_report_on_day_14
			t.date     :response_report_on_day_28
			t.date     :response_report_on_day_7
			t.string   :response_classification_day_14, :limit => 2
			t.string   :response_classification_day_28, :limit => 2
			t.string   :response_classification_day_7,  :limit => 2
			t.integer  :response_blasts_day_14
			t.integer  :response_blasts_day_28
			t.integer  :response_blasts_day_7
			t.string   :response_blasts_units_day_14, :limit => 15
			t.string   :response_blasts_units_day_28, :limit => 15
			t.string   :response_blasts_units_day_7,  :limit => 15
			t.integer  :response_in_remission_day_14
			t.integer  :marrow_biopsy_report_found
			t.date     :marrow_biopsy_on
			t.text     :marrow_biopsy_diagnosis
			t.integer  :marrow_aspirate_report_found
			t.date     :marrow_aspirate_taken_on
			t.text     :marrow_aspirate_diagnosis
			t.integer  :response_marrow_kappa_day_14
			t.integer  :response_marrow_kappa_day_7
			t.integer  :response_marrow_lambda_day_14
			t.integer  :response_marrow_lambda_day_7
			t.integer  :cbc_report_found
			t.date     :cbc_report_on
			t.decimal  :cbc_white_blood_count
			t.integer  :cbc_percent_blasts
			t.integer  :cbc_number_blasts
			t.decimal  :cbc_hemoglobin_level
			t.integer  :cbc_platelet_count
			t.integer  :cerebrospinal_fluid_report_found
			t.date     :csf_report_on
			t.integer  :csf_white_blood_count
			t.text     :csf_white_blood_count_text
			t.integer  :csf_red_blood_count
			t.string   :csf_red_blood_count_text
			t.string   :blasts_are_present
			t.integer  :number_of_blasts
			t.string   :peripheral_blood_in_csf
			t.text     :csf_comment
#			t.string   :chemo_protocol_report_found
			t.integer  :chemo_protocol_report_found
			t.integer  :patient_on_chemo_protocol
			t.string   :chemo_protocol_name
			t.text     :chemo_protocol_agent_description
			t.string   :response_cd10_day_14, :limit => 10
			t.string   :response_cd10_day_7,  :limit => 10
			t.string   :response_cd13_day_14, :limit => 10
			t.string   :response_cd13_day_7,  :limit => 10
			t.string   :response_cd14_day_14, :limit => 10
			t.string   :response_cd14_day_7,  :limit => 10
			t.string   :response_cd15_day_14, :limit => 10
			t.string   :response_cd15_day_7,  :limit => 10
			t.string   :response_cd19_day_14, :limit => 10
			t.string   :response_cd19_day_7,  :limit => 10
			t.string   :response_cd19cd10_day_14, :limit => 10
			t.string   :response_cd19cd10_day_7,  :limit => 10
			t.string   :response_cd1a_day_14, :limit => 10
			t.string   :response_cd2a_day_14, :limit => 10
			t.string   :response_cd20_day_14, :limit => 10
			t.string   :response_cd20_day_7,  :limit => 10
			t.string   :response_cd3a_day_14, :limit => 10
			t.string   :response_cd3_day_7,   :limit => 10
			t.string   :response_cd33_day_14, :limit => 10
			t.string   :response_cd33_day_7,  :limit => 10
			t.string   :response_cd34_day_14, :limit => 10
			t.string   :response_cd34_day_7,  :limit => 10
			t.string   :response_cd4a_day_14, :limit => 10
			t.string   :response_cd5a_day_14, :limit => 10
			t.string   :response_cd56_day_14, :limit => 10
			t.string   :response_cd61_day_14, :limit => 10
			t.string   :response_cd7a_day_14, :limit => 10
			t.string   :response_cd8a_day_14, :limit => 10
			t.integer  :response_day30_is_in_remission
#			t.string   :chest_imaging_report_found, :limit => 5
			t.integer  :chest_imaging_report_found
			t.date     :chest_imaging_report_on
#			t.string   :mediastial_mass_present, :limit => 18
			t.integer  :mediastinal_mass_present
			t.text     :chest_imaging_comment
#			t.string   :received_chest_ct, :limit => 50
			t.integer  :received_chest_ct
#			t.string   :chest_ct_taken_on, :limit => 50
			t.date     :chest_ct_taken_on
#			t.string   :chest_ct_medmass_present, :limit => 50
			t.integer  :chest_ct_medmass_present
#			t.datetime :created_at	# todo created_at used by rails
#			t.integer  :created_by
#			t.integer  :user_id
			t.integer  :cytogen_trisomy10
			t.integer  :cytogen_trisomy17
			t.integer  :cytogen_trisomy21
			t.integer  :is_down_syndrome_phenotype
			t.integer  :cytogen_trisomy4
			t.integer  :cytogen_trisomy5
#			t.string   :cytogen_report_found, :limit => 5
			t.integer  :cytogen_report_found
			t.date     :cytogen_report_on
			t.string   :conventional_karyotype_results
			t.string   :normal_cytogen, :limit => 5
			t.string   :is_cytogen_hosp_fish_t1221_done, :limit => 5
			t.string   :is_karyotype_normal, :limit => 5
			t.integer  :number_normal_metaphase_karyotype
			t.integer  :number_metaphase_tested_karyotype
			t.text     :cytogen_comment
			t.boolean  :is_verification_complete
			t.text     :discharge_summary
			t.integer  :diagnosis_is_b_all
			t.integer  :diagnosis_is_t_all
#			t.string   :diagnosis_is_all,   :limit => 20
#			t.string   :diagnosis_all_type, :limit => 20
#			t.string   :diagnosis_is_cml,   :limit => 20
#			t.string   :diagnosis_is_cll,   :limit => 20
#			t.string   :diagnosis_is_aml,   :limit => 20
#			t.string   :diagnosis_aml_type, :limit => 20
#			t.string   :diagnosis_is_other, :limit => 40
			t.integer  :diagnosis_is_all
			t.integer  :diagnosis_all_type_id
			t.integer  :diagnosis_is_cml
			t.integer  :diagnosis_is_cll
			t.integer  :diagnosis_is_aml
			t.integer  :diagnosis_aml_type_id
			t.integer  :diagnosis_is_other
#			t.string   :flow_cyto_report_found, :limit => 5
			t.integer  :flow_cyto_report_found
			t.integer  :received_flow_cyto_day_14
			t.integer  :received_flow_cyto_day_7
			t.date     :flow_cyto_report_on
			t.date     :response_flow_cyto_day_14_on
			t.date     :response_flow_cyto_day_7_on
			t.string   :flow_cyto_cd10, :limit => 10
			t.string   :flow_cyto_igm,  :limit => 10
			t.string   :flow_cyto_igm_text, :limit => 50
			t.string   :flow_cyto_bm_kappa, :limit => 10
			t.string   :flow_cyto_bm_kappa_text, :limit => 50
			t.string   :flow_cyto_bm_lambda, :limit => 10
			t.string   :flow_cyto_bm_lambda_text, :limit => 50
			t.string   :flow_cyto_cd10_19, :limit => 10
			t.string   :flow_cyto_cd10_19_text, :limit => 50
			t.string   :flow_cyto_cd10_text, :limit => 50
			t.string   :flow_cyto_cd19, :limit => 10
			t.string   :flow_cyto_cd19_text, :limit => 50
			t.string   :flow_cyto_cd20, :limit => 10
			t.string   :flow_cyto_cd20_text, :limit => 50
			t.string   :flow_cyto_cd21, :limit => 10
			t.string   :flow_cyto_cd21_text, :limit => 50
			t.string   :flow_cyto_cd22, :limit => 10
			t.string   :flow_cyto_cd22_text, :limit => 50
			t.string   :flow_cyto_cd23, :limit => 10
			t.string   :flow_cyto_cd23_text, :limit => 50
			t.string   :flow_cyto_cd24, :limit => 10
			t.string   :flow_cyto_cd24_text, :limit => 50
			t.string   :flow_cyto_cd40, :limit => 10
			t.string   :flow_cyto_cd40_text, :limit => 50
			t.string   :flow_cyto_surface_ig, :limit => 10
			t.string   :flow_cyto_surface_ig_text, :limit => 50
			t.string   :flow_cyto_cd1a, :limit => 10
			t.string   :flow_cyto_cd1a_text, :limit => 50
			t.string   :flow_cyto_cd2, :limit => 10
			t.string   :flow_cyto_cd2_text, :limit => 50
			t.string   :flow_cyto_cd3, :limit => 10
			t.string   :flow_cyto_cd3_text, :limit => 50
			t.string   :flow_cyto_cd4, :limit => 10
			t.string   :flow_cyto_cd4_text, :limit => 50
			t.string   :flow_cyto_cd5, :limit => 10
			t.string   :flow_cyto_cd5_text, :limit => 50
			t.string   :flow_cyto_cd7, :limit => 10
			t.string   :flow_cyto_cd7_text, :limit => 50
			t.string   :flow_cyto_cd8, :limit => 10
			t.string   :flow_cyto_cd8_text, :limit => 50
			t.string   :flow_cyto_cd3_cd4, :limit => 10
			t.string   :flow_cyto_cd3_cd4_text, :limit => 50
			t.string   :flow_cyto_cd3_cd8, :limit => 10
			t.string   :flow_cyto_cd3_cd8_text, :limit => 50
			t.string   :flow_cyto_cd11b, :limit => 10
			t.string   :flow_cyto_cd11b_text, :limit => 50
			t.string   :flow_cyto_cd11c, :limit => 10
			t.string   :flow_cyto_cd11c_text, :limit => 50
			t.string   :flow_cyto_cd13, :limit => 10
			t.string   :flow_cyto_cd13_text, :limit => 50
			t.string   :flow_cyto_cd15, :limit => 10
			t.string   :flow_cyto_cd15_text, :limit => 50
			t.string   :flow_cyto_cd33, :limit => 10
			t.string   :flow_cyto_cd33_text, :limit => 50
			t.string   :flow_cyto_cd41, :limit => 10
			t.string   :flow_cyto_cd41_text, :limit => 50
			t.string   :flow_cyto_cdw65, :limit => 10
			t.string   :flow_cyto_cdw65_text, :limit => 50
			t.string   :flow_cyto_cd34, :limit => 10
			t.string   :flow_cyto_cd34_text, :limit => 50
			t.string   :flow_cyto_cd61, :limit => 10
			t.string   :flow_cyto_cd61_text, :limit => 50
			t.string   :flow_cyto_cd14, :limit => 10
			t.string   :flow_cyto_cd14_text, :limit => 50
			t.string   :flow_cyto_glycoa, :limit => 10
			t.string   :flow_cyto_glycoa_text, :limit => 50
			t.string   :flow_cyto_cd16, :limit => 10
			t.string   :flow_cyto_cd16_text, :limit => 50
			t.string   :flow_cyto_cd56, :limit => 10
			t.string   :flow_cyto_cd56_text, :limit => 50
			t.string   :flow_cyto_cd57, :limit => 10
			t.string   :flow_cyto_cd57_text, :limit => 50
			t.string   :flow_cyto_cd9, :limit => 10
			t.string   :flow_cyto_cd9_text, :limit => 50
			t.string   :flow_cyto_cd25, :limit => 10
			t.string   :flow_cyto_cd25_text, :limit => 50
			t.string   :flow_cyto_cd38, :limit => 10
			t.string   :flow_cyto_cd38_text, :limit => 50
			t.string   :flow_cyto_cd45, :limit => 10
			t.string   :flow_cyto_cd45_text, :limit => 50
			t.string   :flow_cyto_cd71, :limit => 10
			t.string   :flow_cyto_cd71_text, :limit => 50
			t.string   :flow_cyto_tdt, :limit => 10
			t.string   :flow_cyto_tdt_text, :limit => 50
			t.string   :flow_cyto_hladr, :limit => 10
			t.string   :flow_cyto_hladr_text, :limit => 50
			t.string   :flow_cyto_other_marker_1_name, :limit => 20
			t.string   :flow_cyto_other_marker_1, :limit => 4
			t.string   :flow_cyto_other_marker_1_text, :limit => 50
			t.string   :flow_cyto_other_marker_2_name, :limit => 20
			t.string   :flow_cyto_other_marker_2, :limit => 4
			t.string   :flow_cyto_other_marker_2_text, :limit => 50
			t.string   :flow_cyto_other_marker_3_name, :limit => 20
			t.string   :flow_cyto_other_marker_3, :limit => 4
			t.string   :flow_cyto_other_marker_3_text, :limit => 50
			t.string   :flow_cyto_other_marker_4_name, :limit => 20
			t.string   :flow_cyto_other_marker_4, :limit => 4
			t.string   :flow_cyto_other_marker_4_text, :limit => 50
			t.string   :flow_cyto_other_marker_5_name, :limit => 20
			t.string   :flow_cyto_other_marker_5, :limit => 4
			t.string   :flow_cyto_other_marker_5_text, :limit => 50
			t.text     :flow_cyto_remarks
#			t.string   :tdt_often_found_flow_cytometry, :limit => 5
			t.integer  :tdt_often_found_flow_cytometry
#			t.string   :tdt_report_found, :limit => 5
			t.integer  :tdt_report_found
			t.date     :tdt_report_on
#			t.string   :tdt_positive_or_negative, :limit => 10
			t.integer  :tdt_positive_or_negative
			t.integer  :tdt_numerical_result
			t.boolean  :tdt_found_in_flow_cyto_chart
			t.boolean  :tdt_found_in_separate_report
			t.text     :response_comment_day_7
			t.text     :response_comment_day_14
			t.integer  :cytogen_karyotype_done
			t.integer  :cytogen_hospital_fish_done
			t.string   :hospital_fish_results
			t.integer  :cytogen_ucb_fish_done
			t.string   :ucb_fish_results, :limit => 50
			t.string   :response_hladr_day_14, :limit => 10
			t.string   :response_hladr_day_7, :limit => 10
			t.string   :histo_report_found, :limit => 5
			t.date     :histo_report_on
			t.text     :histo_report_results
			t.date     :diagnosed_on
			t.date     :treatment_began_on
			t.integer  :response_is_inconclusive_day_14
			t.integer  :response_is_inconclusive_day_21
			t.integer  :response_is_inconclusive_day_28
			t.integer  :response_is_inconclusive_day_7
#			t.integer  :abstracted_by
			t.integer  :abstractor_id
			t.date     :abstracted_on
#			t.integer  :reviewed_by
			t.integer  :reviewer_id
			t.date     :reviewed_on
#			t.integer  :data_entry_by
			t.date     :data_entry_done_on
#			t.integer  :abstract_version_number
			t.integer  :flow_cyto_num_results_available
			t.string   :response_other1_value_day_14, :limit => 4
			t.string   :response_other1_value_day_7,  :limit => 4
			t.string   :response_other2_value_day_14, :limit => 4
			t.string   :response_other2_value_day_7,  :limit => 4
			t.string   :response_other3_value_day_14, :limit => 4
			t.string   :response_other4_value_day_14, :limit => 4
			t.string   :response_other5_value_day_14, :limit => 4
#			t.string   :h_and_p_reports_found, :limit => 5
			t.integer  :h_and_p_reports_found
#			t.integer  :received_discharge_summary
			t.boolean  :is_h_and_p_report_found
			t.date     :h_and_p_reports_on
			t.string   :physical_neuro, :limit => 5
			t.string   :physical_other_soft_2, :limit => 5
#			t.string   :vital_status, :limit => 5
			t.integer  :vital_status_id
#			t.datetime :dod
			t.date     :dod
			t.integer  :discharge_summary_found
			t.string   :physical_gingival, :limit => 5
			t.string   :physical_leukemic_skin, :limit => 5
			t.string   :physical_lymph, :limit => 5
			t.string   :physical_spleen, :limit => 5
			t.string   :physical_testicle, :limit => 5
			t.string   :physical_other_soft, :limit => 5
#			t.string   :ploidy_report_found, :limit => 5
			t.integer  :ploidy_report_found
			t.date     :ploidy_report_on
			t.string   :is_hypodiploid, :limit => 5
			t.string   :is_hyperdiploid, :limit => 5
			t.string   :is_diploid, :limit => 5
			t.string   :dna_index, :limit => 5
			t.string   :other_dna_measure, :limit => 15
			t.string   :ploidy_comment, :limit => 100
			t.integer  :hepatomegaly_present
			t.integer  :splenomegaly_present
			t.text     :response_comment
			t.string   :response_other1_name_day_14, :limit => 25
			t.string   :response_other1_name_day_7,  :limit => 25
			t.string   :response_other2_name_day_14, :limit => 25
			t.string   :response_other2_name_day_7,  :limit => 25
			t.string   :response_other3_name_day_14, :limit => 25
			t.string   :response_other4_name_day_14, :limit => 25
			t.string   :response_other5_name_day_14, :limit => 25
			t.string   :fab_classification, :limit => 50
			t.string   :diagnosis_icdo_description, :limit => 55
			t.string   :diagnosis_icdo_number, :limit => 50
			t.string   :cytogen_t1221, :limit => 9
			t.string   :cytogen_inv16, :limit => 9
			t.string   :cytogen_t119,  :limit => 9
			t.string   :cytogen_t821,  :limit => 9
			t.string   :cytogen_t1517, :limit => 9
			t.string   :cytogen_is_hyperdiploidy,  :limit => 5
			t.string   :cytogen_chromosome_number, :limit => 3
			t.string   :cytogen_other_trans_1, :limit => 35
			t.string   :cytogen_other_trans_2, :limit => 35
			t.string   :cytogen_other_trans_3, :limit => 35
			t.string   :cytogen_other_trans_4, :limit => 35
			t.string   :cytogen_other_trans_5, :limit => 35
			t.string   :cytogen_other_trans_6, :limit => 35
			t.string   :cytogen_other_trans_7, :limit => 35
			t.string   :cytogen_other_trans_8, :limit => 35
			t.string   :cytogen_other_trans_9, :limit => 35
			t.string   :cytogen_other_trans_10, :limit => 35
			t.string   :cytogen_t922, :limit => 50
			t.string   :response_fab_subtype, :limit => 15
			t.string   :response_tdt_day_14, :limit => 10
			t.string   :response_tdt_day_7,  :limit => 10
			t.integer  :abstract_version_id
			t.float    :height_at_diagnosis
			t.float    :weight_at_diagnosis
			t.string   :hyperdiploidy_by
			t.boolean  :cbc_percent_blasts_unknown, :default => false
			t.integer  :response_day_7_days_since_treatment_began
			t.integer  :response_day_7_days_since_diagnosis
			t.integer  :response_day_14_days_since_treatment_began
			t.integer  :response_day_14_days_since_diagnosis
			t.integer  :response_day_28_days_since_treatment_began
			t.integer  :response_day_28_days_since_diagnosis
			t.string   :entry_1_by_uid
			t.string   :entry_2_by_uid
			t.string   :merged_by_uid
			t.date     :discharge_summary_found_on
			t.timestamps
		end
	end

	def self.down
		drop_table :abstracts
	end
end
