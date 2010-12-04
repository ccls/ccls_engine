#	==	requires
#	*	address_id
#	*	interviewer_id
#	*	identifier_id
class Interview < Shared
	belongs_to :identifier
#	Occassionally getting .... for when 
#		Instrument Version ... Instrument ... Project was unknown?
#TypeError (can't dup NilClass):
#  app/controllers/interviews_controller.rb:52:in `valid_id_required'
#	has_one :subject, :through => :identifier
#		changed from has_one to delegate to see if better
#	delegate :subject, :to => :identifier

#	I think that these are pushing it a bit far.
#		(they do work though)
#	has_one :homex_outcome, :through => :subject
#	has_one :interview_outcome, :through => :homex_outcome

	#	in order to do nested attributes, can't be delegate
	has_one :subject, :through => :identifier
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
		:if => :subject_relationship_is_other?
	validates_absence_of :subject_relationship_other,
		:message => "not allowed",
		:unless => :subject_relationship_is_other?

	before_save :update_intro_operational_event,
		:if => :intro_letter_sent_on_changed?

	#	Returns string containing respondent's first and last name
	def respondent_full_name
		"#{respondent_first_name} #{respondent_last_name}"
	end

protected

	def subject_relationship_is_other?
		subject_relationship.try(:is_other?)
	end

	def update_intro_operational_event
		oet = OperationalEventType['intro']
#puts identifier.reload.inspect
#puts identifier.subject.inspect
#puts subject.inspect
#		hxe = subject.hx_enrollment
		hxe = identifier.subject.hx_enrollment
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
