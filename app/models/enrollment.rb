#	Rich join of Subject and Project
#	==	requires
#	*	project
class Enrollment < ActiveRecordShared

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

	#	use after_save, rather than before_save,
	#	so that enrollment exists and can be used to create
	# the operational event as the enrollment is validated
#	before_save :create_enrollment_update,
	after_save :create_enrollment_update,
		:if => :is_complete_changed?

#	before_save :create_subject_consents_operational_event,
	after_save :create_subject_consents_operational_event,
		:if => :consented_changed?

#	before_save :create_subject_declines_operational_event,
	after_save :create_subject_declines_operational_event,
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
#			operational_events << OperationalEvent.create!(
			OperationalEvent.create!(
				:enrollment => self,
				:operational_event_type => operational_event_type,
				:occurred_on => occurred_on
			)
		end
	end

	def create_subject_consents_operational_event
		if( ( consented == YNDK[:yes] ) and ( consented_was != YNDK[:yes] ) )
#			operational_events << OperationalEvent.create!(
			OperationalEvent.create!(
				:enrollment => self,
				:operational_event_type => OperationalEventType['subjectConsents'],
				:occurred_on            => consented_on
			)
		end
	end

	def create_subject_declines_operational_event
		if( ( consented == YNDK[:no] ) and ( consented_was != YNDK[:no] ) )
#			operational_events << OperationalEvent.create!(
			OperationalEvent.create!(
				:enrollment => self,
				:operational_event_type => OperationalEventType['subjectDeclines'],
				:occurred_on            => consented_on
			)
		end
	end

end
