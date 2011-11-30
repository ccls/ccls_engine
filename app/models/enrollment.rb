#	Rich join of Subject and Project
#	==	requires
#	*	project
class Enrollment < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :ineligible_reason
	belongs_to :refusal_reason
	belongs_to :document_version
	belongs_to :project
	belongs_to :project_outcome
	has_many   :operational_events
	has_many   :follow_ups

	delegate :is_other?, :to => :ineligible_reason, :allow_nil => true, :prefix => true
	delegate :is_other?, :to => :refusal_reason,    :allow_nil => true, :prefix => true

	validates_presence_of   :project
	validates_uniqueness_of :project_id, :scope => [:study_subject_id], :allow_blank => true

#
#	NOTE validations on the association rather than the foreign key
#		DO NOT get flagged in view.  (ie. an error on refusal_reason IS NOT
#			the same as an error on refusal_reason_id)
#		Recently, I changed all of these to association validations rather
#			than foreign key validations because it ensures an existing association, 
#			but now I see that this may need modified for clarity in the view.
#

#	validate on foreign key rather than association so error shows up correctly in view.
#	validates_presence_of :ineligible_reason,
	validates_presence_of :ineligible_reason_id,
		:message => 'required if ineligible',
		:if => :is_not_eligible?
#	validate on foreign key rather than association so error shows up correctly in view.
#	validates_absence_of :ineligible_reason,
	validates_absence_of :ineligible_reason_id,
		:message => 'not allowed if not ineligible',
		:unless => :is_not_eligible?

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

#	validate on foreign key rather than association so error shows up correctly in view.
#	validates_presence_of :refusal_reason,
	validates_presence_of :refusal_reason_id,
		:if => :not_consented?
#	validate on foreign key rather than association so error shows up correctly in view.
#	validates_absence_of :refusal_reason,
	validates_absence_of :refusal_reason_id,
		:message => "not allowed with consent",
		:unless => :not_consented?

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

#	validate on foreign key rather than association so error shows up correctly in view.
#	validates_absence_of :document_version,
	validates_absence_of :document_version_id,
		:message => "not allowed with unknown consent",
		:if => :consent_unknown?
	
	validates_complete_date_for :consented_on, :allow_nil => true
	validates_complete_date_for :completed_on, :allow_nil => true

	validates_length_of :recruitment_priority,      :maximum => 250, :allow_blank => true
	validates_length_of :ineligible_reason_specify, :maximum => 250, :allow_blank => true
	validates_length_of :other_refusal_reason,      :maximum => 250, :allow_blank => true
	validates_length_of :reason_not_chosen,         :maximum => 250, :allow_blank => true
	validates_length_of :terminated_reason,         :maximum => 250, :allow_blank => true
	validates_length_of :reason_closed,             :maximum => 250, :allow_blank => true

	before_save :create_enrollment_update,
		:if => :is_complete_changed?

	before_save :create_subject_consents_operational_event,
		:if => :consented_changed?

	#	Return boolean of comparison
	#	true only if is_eligible == 2
	def is_not_eligible?
		is_eligible == 2
	end

	#	Return boolean of comparison
	#	true only if is_chosen == 2
	def is_not_chosen?
		is_chosen == 2
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
		consented == 2
	end

	#	Return boolean of comparison
	#	true only if consented == nil or 999
	def consent_unknown?
		[nil,999].include?(consented)	#	not 1 or 2
	end

	#	Return boolean of comparison
	#	true only if terminated_participation == 1
	def terminated_participation?
		terminated_participation == 1
	end

	#	Return boolean of comparison
	#	true only if is_complete == 1
	def is_complete?
		is_complete == 1
	end

protected

	def create_enrollment_update
		operational_event_type, occurred_on = if( is_complete == YNDK[:yes] )
			[OperationalEventType['complete'], completed_on]
		elsif( is_complete_was == YNDK[:yes] )
			[OperationalEventType['reopened'], Date.today]
		else 
			[nil, nil]
		end
		unless operational_event_type.nil?
			operational_events << OperationalEvent.create!(
				:operational_event_type => operational_event_type,
				:occurred_on => occurred_on
			)
		end
	end

	def create_subject_consents_operational_event
		if( ( consented == YNDK[:yes] ) and ( consented_was != YNDK[:yes] ) )
			operational_events << OperationalEvent.create!(
				:operational_event_type => OperationalEventType['subjectConsents'],
				:occurred_on            => consented_on
			)
		end
	end

end
