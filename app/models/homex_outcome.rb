# don't know exactly
class HomexOutcome < Shared
	acts_as_list
	default_scope :order => :position

	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :sample_outcome
	belongs_to :interview_outcome

	##	TODO - find a way to do this
	# because subject accepts_nested_attributes for homex_outcome
	# we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true

	validates_presence_of :sample_outcome_on,
		:if => :sample_outcome_id?

	validates_presence_of :interview_outcome_on,
		:if => :interview_outcome_id?

	validates_complete_date_for :interview_outcome_on, :allow_nil => true
	validates_complete_date_for :sample_outcome_on,    :allow_nil => true

	before_save :create_interview_outcome_update,
		:if => :interview_outcome_id_changed?

	before_save :create_sample_outcome_update,
		:if => :sample_outcome_id_changed?

	class NoHomeExposureEnrollment < StandardError	#	:nodoc:
	end

protected

	#	Create OperationalEvent regarding the interview outcome
	def create_interview_outcome_update
		operational_event_type = case interview_outcome 
			when InterviewOutcome['scheduled']
				OperationalEventType['scheduled']
			when InterviewOutcome['complete']
				OperationalEventType['iv_complete']
			else nil
		end
		unless operational_event_type.nil?
			raise NoHomeExposureEnrollment if subject.hx_enrollment.nil?
			subject.hx_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => operational_event_type,
				:occurred_on => interview_outcome_on
			)
		end
	end

	#	Create OperationalEvent regarding the sample outcome
	def create_sample_outcome_update
		operational_event_type = case sample_outcome 
			when SampleOutcome['sent']
				OperationalEventType['kit_sent']
			when SampleOutcome['received']
				OperationalEventType['sample_received']
			when SampleOutcome['complete']
				OperationalEventType['sample_complete']
			else nil
		end
		unless operational_event_type.nil?
			raise NoHomeExposureEnrollment if subject.hx_enrollment.nil?
			subject.hx_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => operational_event_type,
				:occurred_on => sample_outcome_on
			)
		end
	end

end
