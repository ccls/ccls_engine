#	Rich join of Subject and Project
#	==	requires
#	*	study_subject_id
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

	validates_uniqueness_of :project_id, :scope => [:study_subject_id]
	validates_presence_of :project_id
	validates_presence_of :project


	##	TODO - find a way to do this
	# because study_subject now accepts_nested_attributes for enrollments
	# we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	validates_presence_of   :study_subject, :on => :update
#	validates_presence_of :study_subject_id
#	validates_presence_of :study_subject


	validates_presence_of :ineligible_reason,
		:message => 'required if ineligible',
		:if => :is_not_eligible?
	validates_absence_of :ineligible_reason,
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

	validates_presence_of :refusal_reason,
		:if => :not_consented?
	validates_absence_of :refusal_reason,
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

	validates_absence_of :document_version,
		:message => "not allowed with unknown consent",
		:if => :consent_unknown?
	
	validates_complete_date_for :consented_on, :allow_nil => true
	validates_complete_date_for :completed_on, :allow_nil => true

	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :recruitment_priority
		o.validates_length_of :ineligible_reason_specify
		o.validates_length_of :other_refusal_reason
		o.validates_length_of :reason_not_chosen
		o.validates_length_of :terminated_reason
		o.validates_length_of :reason_closed
	end

	before_save :create_enrollment_update,
		:if => :is_complete_changed?

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

	def ineligible_reason_is_other?
		ineligible_reason.try(:is_other?)
	end

	def refusal_reason_is_other?
		refusal_reason.try(:is_other?)
	end

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

end
