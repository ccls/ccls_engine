#	Abstract model
class Abstract < ActiveRecordShared

	belongs_to :study_subject, :counter_cache => true

	with_options :class_name => 'User', :primary_key => 'uid' do |u|
		u.belongs_to :entry_1_by, :foreign_key => 'entry_1_by_uid'
		u.belongs_to :entry_2_by, :foreign_key => 'entry_2_by_uid'
		u.belongs_to :merged_by,  :foreign_key => 'merged_by_uid'
	end

	with_options :allow_blank => true do |b|
		b.with_options :maximum => 2 do |o|
			o.validates_length_of( :response_classification_day_14 )
			o.validates_length_of( :response_classification_day_28 )
			o.validates_length_of( :response_classification_day_7 )
		end
		b.with_options :maximum => 3 do |o|
			o.validates_length_of( :cytogen_chromosome_number )
		end
		b.with_options :maximum => 4 do |o|
			o.validates_length_of( :flow_cyto_other_marker_1 )
			o.validates_length_of( :flow_cyto_other_marker_2 )
			o.validates_length_of( :flow_cyto_other_marker_3 )
			o.validates_length_of( :flow_cyto_other_marker_4 )
			o.validates_length_of( :flow_cyto_other_marker_5 )
			o.validates_length_of( :response_other1_value_day_14 )
			o.validates_length_of( :response_other1_value_day_7 )
			o.validates_length_of( :response_other2_value_day_14 )
			o.validates_length_of( :response_other2_value_day_7 )
			o.validates_length_of( :response_other3_value_day_14 )
			o.validates_length_of( :response_other4_value_day_14 )
			o.validates_length_of( :response_other5_value_day_14 )
		end
		b.with_options :maximum => 5 do |o|
			o.validates_length_of( :normal_cytogen )
			o.validates_length_of( :is_cytogen_hosp_fish_t1221_done )
			o.validates_length_of( :is_karyotype_normal )
			o.validates_length_of( :physical_neuro )
			o.validates_length_of( :physical_other_soft_2 )
			o.validates_length_of( :physical_gingival )
			o.validates_length_of( :physical_leukemic_skin )
			o.validates_length_of( :physical_lymph )
			o.validates_length_of( :physical_spleen )
			o.validates_length_of( :physical_testicle )
			o.validates_length_of( :physical_other_soft )
			o.validates_length_of( :is_hypodiploid )
			o.validates_length_of( :is_hyperdiploid )
			o.validates_length_of( :is_diploid )
			o.validates_length_of( :dna_index )
			o.validates_length_of( :cytogen_is_hyperdiploidy )
		end
		b.with_options :maximum => 9 do |o|
			o.validates_length_of( :cytogen_t1221 )
			o.validates_length_of( :cytogen_inv16 )
			o.validates_length_of( :cytogen_t119 )
			o.validates_length_of( :cytogen_t821 )
			o.validates_length_of( :cytogen_t1517 )
		end
		b.with_options :maximum => 10 do |o|
			o.validates_length_of( :response_cd10_day_14 )
			o.validates_length_of( :response_cd10_day_7 )
			o.validates_length_of( :response_cd13_day_14 )
			o.validates_length_of( :response_cd13_day_7 )
			o.validates_length_of( :response_cd14_day_14 )
			o.validates_length_of( :response_cd14_day_7 )
			o.validates_length_of( :response_cd15_day_14 )
			o.validates_length_of( :response_cd15_day_7 )
			o.validates_length_of( :response_cd19_day_14 )
			o.validates_length_of( :response_cd19_day_7 )
			o.validates_length_of( :response_cd19cd10_day_14 )
			o.validates_length_of( :response_cd19cd10_day_7 )
			o.validates_length_of( :response_cd1a_day_14 )
			o.validates_length_of( :response_cd2a_day_14 )
			o.validates_length_of( :response_cd20_day_14 )
			o.validates_length_of( :response_cd20_day_7 )
			o.validates_length_of( :response_cd3a_day_14 )
			o.validates_length_of( :response_cd3_day_7 )
			o.validates_length_of( :response_cd33_day_14 )
			o.validates_length_of( :response_cd33_day_7 )
			o.validates_length_of( :response_cd34_day_14 )
			o.validates_length_of( :response_cd34_day_7 )
			o.validates_length_of( :response_cd4a_day_14 )
			o.validates_length_of( :response_cd5a_day_14 )
			o.validates_length_of( :response_cd56_day_14 )
			o.validates_length_of( :response_cd61_day_14 )
			o.validates_length_of( :response_cd7a_day_14 )
			o.validates_length_of( :response_cd8a_day_14 )
			o.validates_length_of( :flow_cyto_cd10 )
			o.validates_length_of( :flow_cyto_igm )
			o.validates_length_of( :flow_cyto_bm_kappa )
			o.validates_length_of( :flow_cyto_bm_lambda )
			o.validates_length_of( :flow_cyto_cd10_19 )
			o.validates_length_of( :flow_cyto_cd19 )
			o.validates_length_of( :flow_cyto_cd20 )
			o.validates_length_of( :flow_cyto_cd21 )
			o.validates_length_of( :flow_cyto_cd22 )
			o.validates_length_of( :flow_cyto_cd23 )
			o.validates_length_of( :flow_cyto_cd24 )
			o.validates_length_of( :flow_cyto_cd40 )
			o.validates_length_of( :flow_cyto_surface_ig )
			o.validates_length_of( :flow_cyto_cd1a )
			o.validates_length_of( :flow_cyto_cd2 )
			o.validates_length_of( :flow_cyto_cd3 )
			o.validates_length_of( :flow_cyto_cd4 )
			o.validates_length_of( :flow_cyto_cd5 )
			o.validates_length_of( :flow_cyto_cd7 )
			o.validates_length_of( :flow_cyto_cd8 )
			o.validates_length_of( :flow_cyto_cd3_cd4 )
			o.validates_length_of( :flow_cyto_cd3_cd8 )
			o.validates_length_of( :flow_cyto_cd11b )
			o.validates_length_of( :flow_cyto_cd11c )
			o.validates_length_of( :flow_cyto_cd13 )
			o.validates_length_of( :flow_cyto_cd15 )
			o.validates_length_of( :flow_cyto_cd33 )
			o.validates_length_of( :flow_cyto_cd41 )
			o.validates_length_of( :flow_cyto_cdw65 )
			o.validates_length_of( :flow_cyto_cd34 )
			o.validates_length_of( :flow_cyto_cd61 )
			o.validates_length_of( :flow_cyto_cd14 )
			o.validates_length_of( :flow_cyto_glycoa )
			o.validates_length_of( :flow_cyto_cd16 )
			o.validates_length_of( :flow_cyto_cd56 )
			o.validates_length_of( :flow_cyto_cd57 )
			o.validates_length_of( :flow_cyto_cd9 )
			o.validates_length_of( :flow_cyto_cd25 )
			o.validates_length_of( :flow_cyto_cd38 )
			o.validates_length_of( :flow_cyto_cd45 )
			o.validates_length_of( :flow_cyto_cd71 )
			o.validates_length_of( :flow_cyto_tdt )
			o.validates_length_of( :flow_cyto_hladr )
			o.validates_length_of( :response_hladr_day_14 )
			o.validates_length_of( :response_hladr_day_7 )
			o.validates_length_of( :response_tdt_day_14 )
			o.validates_length_of( :response_tdt_day_7 )
		end
		b.with_options :maximum => 15 do |o|
			o.validates_length_of( :response_blasts_units_day_14 )
			o.validates_length_of( :response_blasts_units_day_28 )
			o.validates_length_of( :response_blasts_units_day_7 )
			o.validates_length_of( :other_dna_measure )
			o.validates_length_of( :response_fab_subtype )
		end
		b.with_options :maximum => 20 do |o|
			o.validates_length_of( :flow_cyto_other_marker_1_name )
			o.validates_length_of( :flow_cyto_other_marker_2_name )
			o.validates_length_of( :flow_cyto_other_marker_3_name )
			o.validates_length_of( :flow_cyto_other_marker_4_name )
			o.validates_length_of( :flow_cyto_other_marker_5_name )
		end
		b.with_options :maximum => 25 do |o|
			o.validates_length_of( :response_other1_name_day_14 )
			o.validates_length_of( :response_other1_name_day_7 )
			o.validates_length_of( :response_other2_name_day_14 )
			o.validates_length_of( :response_other2_name_day_7 )
			o.validates_length_of( :response_other3_name_day_14 )
			o.validates_length_of( :response_other4_name_day_14 )
			o.validates_length_of( :response_other5_name_day_14 )
		end
		b.with_options :maximum => 35 do |o|
			o.validates_length_of( :cytogen_other_trans_1 )
			o.validates_length_of( :cytogen_other_trans_2 )
			o.validates_length_of( :cytogen_other_trans_3 )
			o.validates_length_of( :cytogen_other_trans_4 )
			o.validates_length_of( :cytogen_other_trans_5 )
			o.validates_length_of( :cytogen_other_trans_6 )
			o.validates_length_of( :cytogen_other_trans_7 )
			o.validates_length_of( :cytogen_other_trans_8 )
			o.validates_length_of( :cytogen_other_trans_9 )
			o.validates_length_of( :cytogen_other_trans_10 )
		end
		b.with_options :maximum => 50 do |o|
			o.validates_length_of( :flow_cyto_igm_text )
			o.validates_length_of( :flow_cyto_bm_kappa_text )
			o.validates_length_of( :flow_cyto_bm_lambda_text )
			o.validates_length_of( :flow_cyto_cd10_19_text )
			o.validates_length_of( :flow_cyto_cd10_text )
			o.validates_length_of( :flow_cyto_cd19_text )
			o.validates_length_of( :flow_cyto_cd20_text )
			o.validates_length_of( :flow_cyto_cd21_text )
			o.validates_length_of( :flow_cyto_cd22_text )
			o.validates_length_of( :flow_cyto_cd23_text )
			o.validates_length_of( :flow_cyto_cd24_text )
			o.validates_length_of( :flow_cyto_cd40_text )
			o.validates_length_of( :flow_cyto_surface_ig_text )
			o.validates_length_of( :flow_cyto_cd1a_text )
			o.validates_length_of( :flow_cyto_cd2_text )
			o.validates_length_of( :flow_cyto_cd3_text )
			o.validates_length_of( :flow_cyto_cd4_text )
			o.validates_length_of( :flow_cyto_cd5_text )
			o.validates_length_of( :flow_cyto_cd7_text )
			o.validates_length_of( :flow_cyto_cd8_text )
			o.validates_length_of( :flow_cyto_cd3_cd4_text )
			o.validates_length_of( :flow_cyto_cd3_cd8_text )
			o.validates_length_of( :flow_cyto_cd11b_text )
			o.validates_length_of( :flow_cyto_cd11c_text )
			o.validates_length_of( :flow_cyto_cd13_text )
			o.validates_length_of( :flow_cyto_cd15_text )
			o.validates_length_of( :flow_cyto_cd33_text )
			o.validates_length_of( :flow_cyto_cd41_text )
			o.validates_length_of( :flow_cyto_cdw65_text )
			o.validates_length_of( :flow_cyto_cd34_text )
			o.validates_length_of( :flow_cyto_cd61_text )
			o.validates_length_of( :flow_cyto_cd14_text )
			o.validates_length_of( :flow_cyto_glycoa_text )
			o.validates_length_of( :flow_cyto_cd16_text )
			o.validates_length_of( :flow_cyto_cd56_text )
			o.validates_length_of( :flow_cyto_cd57_text )
			o.validates_length_of( :flow_cyto_cd9_text )
			o.validates_length_of( :flow_cyto_cd25_text )
			o.validates_length_of( :flow_cyto_cd38_text )
			o.validates_length_of( :flow_cyto_cd45_text )
			o.validates_length_of( :flow_cyto_cd71_text )
			o.validates_length_of( :flow_cyto_tdt_text )
			o.validates_length_of( :flow_cyto_hladr_text )
			o.validates_length_of( :flow_cyto_other_marker_1_text )
			o.validates_length_of( :flow_cyto_other_marker_2_text )
			o.validates_length_of( :flow_cyto_other_marker_3_text )
			o.validates_length_of( :flow_cyto_other_marker_4_text )
			o.validates_length_of( :flow_cyto_other_marker_5_text )
			o.validates_length_of( :ucb_fish_results )
			o.validates_length_of( :fab_classification )
			o.validates_length_of( :diagnosis_icdo_number )
			o.validates_length_of( :cytogen_t922 )
		end
		b.with_options :maximum => 55 do |o|
			o.validates_length_of( :diagnosis_icdo_description )
		end
		b.with_options :maximum => 100 do |o|
			o.validates_length_of( :ploidy_comment )
		end
		b.with_options :maximum => 250 do |o|
			o.validates_length_of( :csf_red_blood_count_text )
			o.validates_length_of( :blasts_are_present )
			o.validates_length_of( :peripheral_blood_in_csf )
			o.validates_length_of( :chemo_protocol_report_found )
			o.validates_length_of( :chemo_protocol_name )
			o.validates_length_of( :conventional_karyotype_results )
			o.validates_length_of( :hospital_fish_results )
			o.validates_length_of( :hyperdiploidy_by )
		end
		b.with_options :maximum => 65000 do |o|
			o.validates_length_of( :marrow_biopsy_diagnosis )
			o.validates_length_of( :marrow_aspirate_diagnosis )
			o.validates_length_of( :csf_white_blood_count_text )
			o.validates_length_of( :csf_comment )
			o.validates_length_of( :chemo_protocol_agent_description )
			o.validates_length_of( :chest_imaging_comment )
			o.validates_length_of( :cytogen_comment )
			o.validates_length_of( :discharge_summary )
			o.validates_length_of( :flow_cyto_remarks )
			o.validates_length_of( :response_comment_day_7 )
			o.validates_length_of( :response_comment_day_14 )
			o.validates_length_of( :histo_report_results )
			o.validates_length_of( :response_comment )
		end
	end

	attr_protected :study_subject_id
	attr_protected :entry_1_by_uid
	attr_protected :entry_2_by_uid
	attr_protected :merged_by_uid

	attr_accessor :current_user
	attr_accessor :weight_units, :height_units
	attr_accessor :merging	#	flag to be used to skip 2 abstract limitation

	#	The :on => :create doesn't seem to work as described
	#	validate_on_create is technically deprecated, but still works
	validate_on_create :subject_has_less_than_three_abstracts	#, :on => :create
	validate_on_create :subject_has_no_merged_abstract	#, :on => :create

	before_create :set_user
	after_create  :delete_unmerged
	before_save   :convert_height_to_cm
	before_save   :convert_weight_to_kg
	before_save   :set_days_since_fields

	def self.fields
		#	db: db field name
		#	human: humanized field
		@@fields ||= YAML::load( ERB.new( IO.read(
			File.join(File.dirname(__FILE__),'../../config/abstract_fields.yml')
		)).result)
	end

	def fields
		Abstract.fields
	end

	def self.db_fields
#		@db_fields ||= fields.collect{|f|f[:db]}
		Abstract.fields.collect{|f|f[:db]}
	end

	def db_fields
		Abstract.db_fields
	end

	def comparable_attributes
		HashWithIndifferentAccess[attributes.select {|k,v| db_fields.include?(k)}]
	end

	def is_the_same_as?(another_abstract)
		self.diff(another_abstract).blank?
	end

	def diff(another_abstract)
		a1 = self.comparable_attributes
		a2 = Abstract.find(another_abstract).comparable_attributes
		HashWithIndifferentAccess[a1.select{|k,v| a2[k] != v unless( a2[k].blank? && v.blank? ) }]
	end

	def self.search(params={})
		#	TODO	stop using this.  Now that study subjects and abstracts are in
		#		the same database, this should be simplified.  Particularly since
		#		the only searching is really on the study subject and not the abstract.
		AbstractSearch.new(params).abstracts
	end

	def self.sections
		#	:label: Cytogenetics
		#	:controller: CytogeneticsController
		#	:edit:  :edit_abstract_cytogenetic_path
		#	:show:  :abstract_cytogenetic_path
		@@sections ||= YAML::load(ERB.new( IO.read(
			File.join(File.dirname(__FILE__),'../../config/abstract_sections.yml')
		)).result)
	end

	def merged?
		!merged_by_uid.blank?
	end

protected

	def set_days_since_fields
		#	must explicitly convert these DateTimes to Date so that the
		#	difference is in days and not seconds
		#	I really only need to do this if something changes,
		#	but for now, just do it and make sure that
		#	it is tested.  Optimize and refactor later.
		unless diagnosed_on.nil?
			self.response_day_7_days_since_diagnosis = (
				response_report_on_day_7.to_date - diagnosed_on.to_date 
				) unless response_report_on_day_7.nil?
			self.response_day_14_days_since_diagnosis = (
				response_report_on_day_14.to_date - diagnosed_on.to_date 
				) unless response_report_on_day_14.nil?
			self.response_day_28_days_since_diagnosis = (
				response_report_on_day_28.to_date - diagnosed_on.to_date 
				) unless response_report_on_day_28.nil?
		end
		unless treatment_began_on.nil?
			self.response_day_7_days_since_treatment_began = (
				response_report_on_day_7.to_date - treatment_began_on.to_date 
				) unless response_report_on_day_7.nil?
			self.response_day_14_days_since_treatment_began = (
				response_report_on_day_14.to_date - treatment_began_on.to_date 
				) unless response_report_on_day_14.nil?
			self.response_day_28_days_since_treatment_began = (
				response_report_on_day_28.to_date - treatment_began_on.to_date 
				) unless response_report_on_day_28.nil?
		end
	end

	def convert_height_to_cm
		if( !height_units.nil? && height_units.match(/in/i) )
			self.height_units = nil
			self.height_at_diagnosis *= 2.54
		end
	end

	def convert_weight_to_kg
		if( !weight_units.nil? && weight_units.match(/lb/i) )
			self.weight_units = nil
			self.weight_at_diagnosis /= 2.2046
		end
	end

	#	Set user if given
	def set_user
		if study_subject
			#	because it is possible to create the first, then the second
			#	and then delete the first, and create another, first and
			#	second kinda lose their meaning until the merge, so set them
			#	both as the same until the merge
			case study_subject.abstracts_count
				when 0 
					self.entry_1_by_uid = current_user.try(:uid)||0
					self.entry_2_by_uid = current_user.try(:uid)||0
				when 1 
					self.entry_1_by_uid = current_user.try(:uid)||0
					self.entry_2_by_uid = current_user.try(:uid)||0
				when 2
					abs = study_subject.abstracts
					#	compact just in case a nil crept in
					self.entry_1_by_uid = [abs[0].entry_1_by_uid,abs[0].entry_2_by_uid].compact.first
					self.entry_2_by_uid = [abs[1].entry_1_by_uid,abs[1].entry_2_by_uid].compact.first
					self.merged_by_uid  = current_user.try(:uid)||0
			end
		end
	end

	def delete_unmerged
		if study_subject and !merged_by_uid.blank?
			#	use delete and not destroy to preserve the abstracts_count
			study_subject.unmerged_abstracts.each{|a|a.delete}
		end
	end

	def subject_has_less_than_three_abstracts
		#	because this abstract hasn't been created yet, we're comparing to 2, not 3
		if study_subject and study_subject.abstracts_count >= 2
			errors.add(:study_subject_id,"Study Subject can only have 2 abstracts." ) unless merging
		end
	end

	def subject_has_no_merged_abstract
		if study_subject and study_subject.merged_abstract
			errors.add(:study_subject_id,"Study Subject already has a merged abstract." )
		end
	end

end
