#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module EnrollmentValidations
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	validates_presence_of   :project_id
	validates_presence_of   :project, :if => :project_id
	validates_uniqueness_of :project_id, :scope => [:study_subject_id], :allow_blank => true

	validates_length_of :notes, :maximum => 65000, :allow_blank => true

	validates_presence_of :ineligible_reason_id,
		:message => 'required if is_eligible is No',
		:if => :is_not_eligible?
	validates_absence_of :ineligible_reason_id,
		:message => 'not allowed unless is_eligible is No',
		:unless => :is_not_eligible?
	validates_presence_of :ineligible_reason, :if => :ineligible_reason_id

	validates_presence_of :ineligible_reason_specify,
		:message => 'required if ineligible reason is Other',
		:if => :ineligible_reason_is_other?
	validates_absence_of :ineligible_reason_specify,
		:message => 'not allowed unless is_eligible is No',
		:unless => :is_not_eligible?

	validates_presence_of :reason_not_chosen,
		:message => 'requires if is_chosen is No',
		:if => :is_not_chosen?
	validates_absence_of :reason_not_chosen,
		:message => 'not allowed unless is_chosen is No',
		:unless => :is_not_chosen?

	validates_presence_of :refusal_reason_id,
		:message => "required if consented is No",
		:if => :not_consented?
	validates_absence_of :refusal_reason_id,
		:message => "not allowed unless consented is No",
		:unless => :not_consented?
	validates_presence_of :refusal_reason, :if => :refusal_reason_id

#	validates_presence_of :consented_on,
#		:message => 'date is required when adding consent information',
#		:if => :consented?
	validates_presence_of :consented_on,
		:message => 'date is required when adding consent information',
		:unless => :consent_unknown?
#		:if => :not_consented?
	validates_absence_of :consented_on,
		:message => "not allowed if consented is blank or Don't Know",
		:if => :consent_unknown?
	validates_past_date_for :consented_on

	validates_presence_of :other_refusal_reason,
		:message => "required if refusal reason is Other",
		:if => :refusal_reason_is_other?
	validates_absence_of :other_refusal_reason,
		:message => "not allowed unless consented is No",
		:unless => :not_consented?

	validates_presence_of :terminated_reason,
		:message => "required if terminated participation is Yes",
		:if => :terminated_participation?
	validates_absence_of :terminated_reason,
		:message => "not allowed unless terminated participation is Yes",
		:unless => :terminated_participation?

	validates_presence_of :completed_on,
		:message => "required if is_complete is Yes",
		:if => :is_complete?
	validates_absence_of :completed_on,
		:message => "not allowed unless is_complete is Yes",
		:unless => :is_complete?
	validates_past_date_for :completed_on

	validates_absence_of :document_version_id,
		:message => "not allowed if consented is blank or Don't Know",
		:if => :consent_unknown?
	validates_presence_of :document_version, :if => :document_version_id
	
	validates_complete_date_for :consented_on, :allow_nil => true
	validates_complete_date_for :completed_on, :allow_nil => true

	validates_length_of :recruitment_priority,      :maximum => 250, :allow_blank => true
	validates_length_of :ineligible_reason_specify, :maximum => 250, :allow_blank => true
	validates_length_of :other_refusal_reason,      :maximum => 250, :allow_blank => true
	validates_length_of :reason_not_chosen,         :maximum => 250, :allow_blank => true
	validates_length_of :terminated_reason,         :maximum => 250, :allow_blank => true
	validates_length_of :reason_closed,             :maximum => 250, :allow_blank => true


	validates_inclusion_of :consented, :is_eligible,
		:is_chosen, :is_complete, :terminated_participation,
		:is_candidate,
			:in => YNDK.valid_values, :allow_nil => true

	validates_inclusion_of :use_smp_future_rsrch,
		:use_smp_future_cancer_rsrch, :use_smp_future_other_rsrch,
		:share_smp_with_others, :contact_for_related_study,
		:provide_saliva_smp, :receive_study_findings,
			:in => ADNA.valid_values, :allow_nil => true


#
#	NOTE: BEWARE of POSSIBLE strings in these comparisons.
#		Rails SHOULD actually convert the incoming 
#		params (which are strings) to integers or nil.
#

	#	Return boolean of comparison
	#	true only if is_eligible == 2
	def is_not_eligible?
#		is_eligible.to_i == YNDK[:no]	#2
		is_eligible == YNDK[:no]	#2
	end

	#	Return boolean of comparison
	#	true only if is_chosen == 2
	def is_not_chosen?
#		is_chosen.to_i == YNDK[:no]	#2
		is_chosen == YNDK[:no]	#2
	end

	#	Return boolean of comparison
	#	true only if consented == 1
#	no longer used, I believe
#	def consented?
#		consented == 1
#	end

	#	Return boolean of comparison
	#	true only if consented == 2
	def not_consented?
#		consented.to_i == YNDK[:no]	#2
		consented == YNDK[:no]	#2
	end

	#	Return boolean of comparison
	#	true only if consented == nil or 999
	def consent_unknown?
#		[nil,999,'','999'].include?(consented)	#	not 1 or 2
		[nil,999].include?(consented)	#	not 1 or 2
	end

	#	Return boolean of comparison
	#	true only if terminated_participation == 1
	def terminated_participation?
#		terminated_participation.to_i == YNDK[:yes]	#	1
		terminated_participation == YNDK[:yes]	#	1
	end

	#	Return boolean of comparison
	#	true only if is_complete == 1
	def is_complete?
#		is_complete.to_i == YNDK[:yes]	#	1
		is_complete == YNDK[:yes]	#	1
	end

end	#	class_eval
end	#	included
end	#	EnrollmentValidations
