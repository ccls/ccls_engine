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

	validates_presence_of :ineligible_reason_id,
		:message => 'required if ineligible',
		:if => :is_not_eligible?
	validates_absence_of :ineligible_reason_id,
		:message => 'not allowed if not ineligible',
		:unless => :is_not_eligible?
	validates_presence_of :ineligible_reason, :if => :ineligible_reason_id

	validates_presence_of :ineligible_reason_specify,
		:if => :ineligible_reason_is_other?
	validates_absence_of :ineligible_reason_specify,
		:message => 'not allowed',
		:unless => :is_not_eligible?

	validates_presence_of :reason_not_chosen,
		:if => :is_not_chosen?
	validates_absence_of :reason_not_chosen,
		:message => 'not allowed',
		:unless => :is_not_chosen?

	validates_presence_of :refusal_reason_id,
		:if => :not_consented?
	validates_absence_of :refusal_reason_id,
		:message => "not allowed with consent",
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
		:message => 'not allowed with unknown consent',
		:if => :consent_unknown?
	validates_past_date_for :consented_on

	validates_presence_of :other_refusal_reason,
		:if => :refusal_reason_is_other?
	validates_absence_of :other_refusal_reason,
		:message => "not allowed",
		:unless => :not_consented?

	validates_presence_of :terminated_reason,
		:if => :terminated_participation?
	validates_absence_of :terminated_reason,
		:message => "not allowed",
		:unless => :terminated_participation?

	validates_presence_of :completed_on,
		:if => :is_complete?
	validates_absence_of :completed_on,
		:message => "not allowed if not complete",
		:unless => :is_complete?
	validates_past_date_for :completed_on

	validates_absence_of :document_version_id,
		:message => "not allowed with unknown consent",
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

	#	Return boolean of comparison
	#	true only if is_eligible == 2
	def is_not_eligible?
		is_eligible.to_i == YNDK[:no]	#2
	end

	#	Return boolean of comparison
	#	true only if is_chosen == 2
	def is_not_chosen?
		is_chosen.to_i == YNDK[:no]	#2
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
		consented.to_i == YNDK[:no]	#2
	end

	#	Return boolean of comparison
	#	true only if consented == nil or 999
	def consent_unknown?
		[nil,999,'','999'].include?(consented)	#	not 1 or 2
	end

	#	Return boolean of comparison
	#	true only if terminated_participation == 1
	def terminated_participation?
		terminated_participation.to_i == YNDK[:yes]	#	1
	end

	#	Return boolean of comparison
	#	true only if is_complete == 1
	def is_complete?
		is_complete.to_i == YNDK[:yes]	#	1
	end

end	#	class_eval
end	#	included
end	#	EnrollmentValidations
