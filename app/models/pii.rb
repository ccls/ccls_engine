# == PII (Personally Identifiable Information)
#	==	requires
#	*	subject_id
class Pii < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :guardian_relationship, :class_name => 'SubjectRelationship'


#
#	TODO - Don't validate anything that the creating user can't do anything about.
#

	##	TODO - find a way to do this
	#	because subject accepts_nested_attributes for pii 
	#	we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	attr_protected :study_subject_id
	validates_presence_of   :subject,          :on => :update
#	validates_uniqueness_of :study_subject_id, :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the subject creation too if using nested attributes.
	before_create :ensure_presence_and_uniqueness_of_study_subject_id

	validates_presence_of       :dob
	validates_complete_date_for :dob, :died_on, :allow_nil => true
	validates_uniqueness_of     :email, :allow_nil => true

	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

	before_validation :nullify_blank_email

#
#	TODO don't like the messaging here
#
	validates_presence_of :guardian_relationship_other,
		:message => "<|X|You must specify a relationship with 'other relationship' is selected",
		:if => :guardian_relationship_is_other?

#
#	TODO gonna need to require some of these names
#
	validates_presence_of :first_name, :last_name
	validates_length_of :first_name, :last_name, :maximum => 250
	validates_length_of :middle_name, :guardian_relationship_other,
		:father_first_name, :father_middle_name, :father_last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
			:maximum => 250, :allow_blank => true

	#	Returns string containing subject's first, middle and last name
	def full_name
		[first_name, middle_name, last_name].compact.join(' ')
	end

	#	Returns string containing subject's father's first, middle and last name
	def fathers_name
		[father_first_name, father_middle_name, father_last_name].compact.join(' ')
	end

	#	Returns string containing subject's mother's first, middle and last name
	def mothers_name
		[mother_first_name, mother_middle_name, mother_last_name].compact.join(' ')
	end

	#	Returns string containing subject's guardian's first, middle and last name
	def guardians_name
		[guardian_first_name, guardian_middle_name, guardian_last_name].compact.join(' ')
	end

#
#	TODO I hate this.  It is revolting.  More?  Yes, please.
#
	#	I don't know if I still need this
	#	commented out 20101014
	#	uncommented 20101014
	def dob	#	overwrite default dob method for formatting
		#	added to_date to fix sqlite3 quirk which doesn't	(why am I using sqlite3?)  old comment?
		#	differentiate between times and dates.
		read_attribute(:dob).try(:to_s,:dob).try(:to_date)
	end

	after_save :trigger_setting_was_under_15_at_dx,
		:if => :dob_changed?
	def trigger_setting_was_under_15_at_dx
		subject.update_patient_was_under_15_at_dx
	end

protected

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the subject creation too if using nested attributes.
	def ensure_presence_and_uniqueness_of_study_subject_id
		if study_subject_id.blank?
			errors.add(:study_subject_id, :blank )
			return false
		#	As this is only on create, we don't need to consider self.id
#		elsif Pii.exists?(:study_subject_id => study_subject_id)
#			errors.add(:study_subject_id, :taken )
#			return false
		end
	end

	def nullify_blank_email
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
	end

	def guardian_relationship_is_other?
		guardian_relationship.try(:is_other?)
	end

end
