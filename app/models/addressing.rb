#	Rich join of Subject and Address
class Addressing < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :address
	belongs_to :data_source

	delegate :is_other?, :to => :data_source, :allow_nil => true, :prefix => true
	delegate :address_type, :address_type_id,
		:line_1,:line_2,:unit,:city,:state,:zip,:csz,:county,
		:to => :address, :allow_nil => true

	attr_accessor :current_user

	#	flag used in study_subject's nested attributes for addressing
	#		to not reject if address fields are blank.
	attr_accessor :address_required

	validates_length_of   :why_invalid,  :maximum => 250, :allow_blank => true
	validates_presence_of :why_invalid,  :if => :is_not_valid?
	validates_length_of   :how_verified, :maximum => 250, :allow_blank => true
	validates_presence_of :how_verified, :if => :is_verified?
	validates_complete_date_for :valid_from, :allow_nil => true
	validates_complete_date_for :valid_to,   :allow_nil => true

	validates_presence_of :data_source_other, :if => :data_source_is_other?

	named_scope :current, :conditions => [
		'current_address IS NOT NULL AND current_address != 2'
	]

	named_scope :historic, :conditions => [
		'current_address IS NULL OR current_address = 2'
	]

	#	Don't do the rejections here.
	accepts_nested_attributes_for :address

	attr_accessor :subject_moved

	after_save :create_subject_moved_event, :if => :subject_moved

	before_save :set_verifier, 
		:if => :is_verified?, 
		:unless => :is_verified_was

	before_save :nullify_verifier, 
		:unless => :is_verified?,
		:if => :is_verified_was

	after_create :check_state_for_eligibilty

	#	Returns boolean of comparison of is_valid == 2 or 999
	def is_not_valid?
		[2,999].include?(is_valid)
	end

protected

	#	Set verified time and user if given
	def set_verifier
		self.verified_on = Time.now
		self.verified_by_uid = current_user.try(:uid)||''
	end

	#	Unset verified time and user
	def nullify_verifier
		self.verified_on = nil
		self.verified_by_uid = nil
	end

	def check_state_for_eligibilty
		if( state != 'CA' && study_subject && 
			( hxe = study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id) ) &&
			address_type == AddressType['residence'] )

			#	This is an after_save so using 1 NOT 0
			ineligible_reason = if( study_subject.residence_addresses_count == 1 )
				IneligibleReason['newnonCA']
			else
				IneligibleReason['moved']
			end

			hxe.update_attributes(
				:is_eligible => YNDK[:no],
				:ineligible_reason => ineligible_reason
			)

			oet = OperationalEventType['ineligible']
			if( oet.blank? )
				errors.add(:base,"OperationalEventType['ineligible'] not found")
				raise ActiveRecord::RecordNotSaved
			end

			hxe.operational_events << OperationalEvent.create!(
				:operational_event_type => oet,
				:occurred_on => Date.today,
				:description => ineligible_reason.to_s
			)

		end
	end

	def create_subject_moved_event
		#	subject_moved will most likely be a string 'true' or 'false'
		#		as it will really only come as a hash value from a view.
		#	.true? is a common_lib#object method.
		if subject_moved.true? &&
				current_address == YNDK[:no] &&
				current_address_was != YNDK[:no] &&
				address.address_type == AddressType['residence']
			ccls_enrollment = study_subject.enrollments.find_or_create_by_project_id(
				Project['ccls'].id)
			ccls_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => OperationalEventType['subject_moved'],
				:occurred_on            => Date.today
			)
		end
	end

end
