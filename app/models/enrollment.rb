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
	belongs_to :tracing_status
	has_many   :operational_events
	has_many   :follow_ups

	delegate :is_other?, :to => :ineligible_reason, :allow_nil => true, :prefix => true
	delegate :is_other?, :to => :refusal_reason,    :allow_nil => true, :prefix => true

	include EnrollmentValidations

	#	use after_save, rather than before_save,
	#	so that enrollment exists and can be used to create
	# the operational event as the enrollment is validated
#	before_save :create_enrollment_update,
	after_save :create_enrollment_update,
		:if => :is_complete_changed?

	after_save :create_subject_consents_operational_event,
		:if => :consented_changed?

	after_save :create_subject_declines_operational_event,
		:if => :consented_changed?

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
			OperationalEvent.create!(
				:enrollment => self,
				:operational_event_type => operational_event_type,
				:occurred_on => occurred_on
			)
		end
	end

	def create_subject_consents_operational_event
		if( ( consented == YNDK[:yes] ) and ( consented_was != YNDK[:yes] ) )
			OperationalEvent.create!(
				:enrollment => self,
				:operational_event_type => OperationalEventType['subjectConsents'],
				:occurred_on            => consented_on
			)
		end
	end

	def create_subject_declines_operational_event
		if( ( consented == YNDK[:no] ) and ( consented_was != YNDK[:no] ) )
			OperationalEvent.create!(
				:enrollment => self,
				:operational_event_type => OperationalEventType['subjectDeclines'],
				:occurred_on            => consented_on
			)
		end
	end

end
