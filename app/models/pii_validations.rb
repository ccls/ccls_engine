#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module PiiValidations
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

#	validate :presence_of_dob, :unless => :dob_not_required?
	validate :presence_of_dob, :unless => :is_mother?
	validates_complete_date_for :dob,     :allow_nil => true
	validates_complete_date_for :died_on, :allow_nil => true
	validates_uniqueness_of     :email,   :allow_nil => true

	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

	validate :presence_of_guardian_relationship_other,
		:if => :guardian_relationship_is_other?

	validates_presence_of :birth_city,
		:if => :birth_country_is_united_states?
	validates_presence_of :birth_state,
		:if => :birth_country_is_united_states?

	validates_length_of :first_name, :last_name, 
		:middle_name, :maiden_name, :guardian_relationship_other,
		:father_first_name, :father_middle_name, :father_last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
		:mother_race_other, :father_race_other,
		:birth_city, :birth_state, :birth_country,
			:maximum => 250, :allow_blank => true

 	validates_length_of :generational_suffix, :father_generational_suffix, 
		:maximum => 10, :allow_blank => true

 	validates_length_of :birth_year, :maximum => 4, :allow_blank => true

#	#	study_subject is not known at validation on creation
#	#	when using the accepts_nested_attributes feature
#	#	so we must explicitly set a flag.
#	#	the subject_is_mother flag is no longer necessary
#	def dob_not_required?
#		subject_is_mother || ( subject_type == SubjectType['Mother'] )
##		subject_is_mother || subject_is_father || 
##			( subject_type == SubjectType['Mother'] ) ||
##			( subject_type == SubjectType['Father'] )
##			( study_subject.try(:subject_type) == SubjectType['Mother'] ) ||
##			( study_subject.try(:subject_type) == SubjectType['Father'] )
#	end

protected

	def birth_country_is_united_states?
		birth_country == 'United States'
	end

	#	custom validation for custom message without standard attribute prefix
	def presence_of_guardian_relationship_other
		if guardian_relationship_other.blank?
			errors.add(:guardian_relationship_other, ActiveRecord::Error.new(
				self, :base, :blank, { 
					:message => "You must specify a relationship with 'other relationship' is selected." } ) )
		end
	end

	#	custom validation for custom message without standard attribute prefix
	def presence_of_dob
		if dob.blank?
			errors.add(:dob, ActiveRecord::Error.new(
				self, :base, :blank, { 
					:message => "Date of birth can't be blank." } ) )
		end
	end

end	#	class_eval
end	#	included
end	#	PiiValidations
