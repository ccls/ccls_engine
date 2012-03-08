#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectAssociations
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	belongs_to :subject_type
	belongs_to :vital_status

	has_and_belongs_to_many :analyses
	has_many :gift_cards
	has_many :phone_numbers
	has_many :samples
	has_one :home_exposure_response
	has_many :bc_requests
	belongs_to :guardian_relationship, :class_name => 'SubjectRelationship'

##########
#
#	Declaration order does matter.  Because of a patient callback that 
#	references the study_subject's dob when using nested attributes, 
#	pii NEEDS to be BEFORE patient.
#
#	identifier should also be before patient
#
#	has_one :identifier
#	has_one :pii
#
##########

end	#	class_eval
end	#	included
end	#	StudySubjectAssociations
