#	Rich join of Subject and Address
class Addressing < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :address

	validates_presence_of :address, :on => :update
	validates_presence_of :study_subject_id, :subject
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :why_invalid
		o.validates_length_of :how_verified
	end

	accepts_nested_attributes_for :address

	delegate :address_type, :address_type_id,
		:line_1,:line_2,:city,:state,:zip,:csz,
		:to => :address, :allow_nil => true

	validates_presence_of :why_invalid,
		:if => :is_not_valid?
	validates_presence_of :how_verified,
		:if => :is_verified?

	validates_complete_date_for :valid_from, :valid_to,
		:allow_nil => true

	named_scope :current, :conditions => {
		:current_address => 1
	}

	named_scope :historic, :conditions => [
		'current_address IS NULL OR current_address != 1'
	]

	before_save :set_verifier, 
		:if => :is_verified?, 
		:unless => :is_verified_was

	before_save :nullify_verifier, 
		:unless => :is_verified?,
		:if => :is_verified_was

	after_create :check_state_for_eligibilty

	attr_accessor :current_user

	#	Returns boolean of comparison of is_valid == 2
	def is_not_valid?
		is_valid == 2
	end

protected

	#	Set verified time and user if given
	def set_verifier
		self.verified_on = Time.now
		self.verified_by_id = current_user.try(:id)||0
	end

	#	Unset verified time and user
	def nullify_verifier
		self.verified_on = nil
		self.verified_by_id = nil
	end

	def check_state_for_eligibilty
		if( state != 'CA' && subject && subject.hx_enrollment &&
			address_type == AddressType['residence'] )

			#	This is an after_save so using 1 NOT 0
			ineligible_reason = if( subject.residence_addresses_count == 1 )
				IneligibleReason['newnonCA']
			else
				IneligibleReason['moved']
			end

			subject.hx_enrollment.update_attributes(
				:is_eligible => YNDK[:no],
				:ineligible_reason => ineligible_reason
			)

			oet = OperationalEventType['ineligible']
			if( oet.blank? )
				errors.add(:base,"OperationalEventType['ineligible'] not found")
				raise ActiveRecord::RecordNotSaved
			end

			subject.hx_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => oet,
				:occurred_on => Date.today,
				:description => ineligible_reason.to_s
			)

		end
	end

end
