#	==	requires
#	*	address_id
#	*	interviewer_id
#	*	subject_id
class Interview < Shared

	belongs_to :subject, :foreign_key => 'study_subject_id'
	accepts_nested_attributes_for :subject

	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	belongs_to :instrument_version
	belongs_to :interview_method
	belongs_to :language
	belongs_to :subject_relationship

	with_options :allow_nil => true do |o|
		o.validates_complete_date_for :began_on
		o.validates_complete_date_for :ended_on
		o.validates_complete_date_for :intro_letter_sent_on
	end
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :subject_relationship_other
		o.validates_length_of :respondent_first_name
		o.validates_length_of :respondent_last_name
	end

	validates_presence_of :subject_relationship_other,
		:message => "<|X|You must specify a relationship with 'other relationship' is selected",
		:if => :subject_relationship_is_other?
	validates_absence_of :subject_relationship_other,
		:message => "not allowed",
		:if => :subject_relationship_id_blank?

	before_save :update_intro_operational_event,
		:if => :intro_letter_sent_on_changed?

	before_save :set_began_at
	before_save :set_ended_at

	#	Returns string containing respondent's first and last name
	def respondent_full_name
		[respondent_first_name, respondent_last_name].compact.join(' ')
	end

protected

	def set_began_at
		if [began_on, began_at_hour,began_at_minute,began_at_meridiem].all?
			self.began_at = DateTime.parse(
				"#{began_on} #{began_at_hour}:#{began_at_minute} #{began_at_meridiem} PST")
		end
	end

	def set_ended_at
		if [ended_on, ended_at_hour,ended_at_minute,ended_at_meridiem].all?
			self.ended_at = DateTime.parse(
				"#{ended_on} #{ended_at_hour}:#{ended_at_minute} #{ended_at_meridiem} PST")
		end
	end

	def subject_relationship_id_blank?
		subject_relationship_id.blank?
	end

	def subject_relationship_is_other?
		subject_relationship.try(:is_other?)
	end

	def update_intro_operational_event
		oet = OperationalEventType['intro']
#		hxe = identifier.subject.hx_enrollment
		hxe = subject.hx_enrollment
		if oet && hxe
			oe = hxe.operational_events.find(:first,
				:conditions => { :operational_event_type_id => oet.id } )
			if oe
				oe.update_attributes(
					:description => oet.description,
					:occurred_on => intro_letter_sent_on
				)
			else
				hxe.operational_events << OperationalEvent.create!(
					:operational_event_type => oet,
					:description => oet.description,
					:occurred_on => intro_letter_sent_on
				)
			end
		end
	end

end
