# == PII (Personally Identifiable Information)
#	==	requires
#	*	study_subject_id
class Pii < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :guardian_relationship, :class_name => 'SubjectRelationship'

	#	Basically, this is only used as a flag during nested creation
	#	to determine if the dob is required.
	attr_accessor :subject_is_mother

#
#	TODO - Don't validate anything that the creating user can't do anything about.
#

	##	TODO - find a better way to do this
	#	because study_subject accepts_nested_attributes for pii 
	#	we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	attr_protected          :study_subject_id
#	validates_presence_of   :study_subject,    :on => :update
#	NOTE This requirement is in the database as well.
#	validates_uniqueness_of :study_subject_id, :allow_nil => true
	#
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the study_subject creation too if using nested attributes.
	#	I don't know that this is ever really an even possible issue
	#	as there is no way to directly create one.
#	before_create :ensure_presence_of_study_subject_id

	before_validation :nullify_blank_email

	validates_presence_of       :dob, :unless => :dob_not_required?
	validates_complete_date_for :dob, :died_on, :allow_nil => true
	validates_uniqueness_of     :email, :allow_nil => true

	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

	#
	#	NOTE I don't like the messaging here, but was requested to have a special
	#		failed validation message.  Normally, rails will give the attribute name
	#		followed by the error message.  I wrote some code that looks for the <|X|
	#		and if it finds it, only displays this message without the attribute.
	#
	validates_presence_of :guardian_relationship_other,
		:message => "<|X|You must specify a relationship with 'other relationship' is selected",
		:if => :guardian_relationship_is_other?

#
#	TODO gonna need to require some of these names
#
	validates_presence_of :first_name, :last_name
	validates_length_of :first_name, :last_name, :maximum => 250
	validates_length_of :middle_name, :maiden_name, :guardian_relationship_other,
		:father_first_name, :father_middle_name, :father_last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
			:maximum => 250, :allow_blank => true

 	validates_length_of :generational_suffix, :father_generational_suffix, 
		:maximum => 10, :allow_blank => true


	#	study_subject is not known at validation on creation
	#	when using the accepts_nested_attributes feature
	#	so we must explicitly set a flag.
	def dob_not_required?
		subject_is_mother || ( study_subject.try(:subject_type) == SubjectType['Mother'] )
	end

	#	Returns string containing study_subject's first, middle and last initials
	def initials
		[first_name, middle_name, last_name].compact.collect{|s|s.chars.first}.join()
	end

	#	Returns string containing study_subject's first, middle and last name
	#	TODO include maiden_name just in case is mother???
	def full_name
		[first_name, middle_name, last_name].compact.join(' ')
	end

	#	Returns string containing study_subject's father's first, middle and last name
	def fathers_name
		[father_first_name, father_middle_name, father_last_name].compact.join(' ')
	end

	#	Returns string containing study_subject's mother's first, middle and last name
	def mothers_name
		[mother_first_name, mother_middle_name, mother_last_name].compact.join(' ')
	end

	#	Returns string containing study_subject's guardian's first, middle and last name
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
		study_subject.update_patient_was_under_15_at_dx
	end

protected

#	TODO I think that I should just remove these as
#		it is realistically not possible to do this through
#		the web app.  Is in Pii, Patient, Identifier.
#	##
#	#	since I can't use the conventional validations to check 
#	#	study_subject_id, do it before_save.  This'll rollback 
#	#	the study_subject creation too if using nested attributes.
##	there is no uniqueness check anymore
#	def ensure_presence_of_study_subject_id
#		if study_subject_id.blank?
#			errors.add(:study_subject_id, :blank )
#			return false
#		#	As this is only on create, we don't need to consider self.id
##		elsif Pii.exists?(:study_subject_id => study_subject_id)
##			errors.add(:study_subject_id, :taken )
##			return false
#		end
#	end

	def nullify_blank_email
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
	end

	def guardian_relationship_is_other?
		guardian_relationship.try(:is_other?)
	end

end
