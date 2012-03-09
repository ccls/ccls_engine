class SubjectRace < ActiveRecordShared

	belongs_to :study_subject
	attr_protected :study_subject_id, :study_subject
	belongs_to :race

	delegate :is_other?, :to => :race, :allow_nil => true, :prefix => true

	validates_presence_of :other, :if => :race_is_other?

end
