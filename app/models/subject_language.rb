class SubjectLanguage < ActiveRecordShared

	belongs_to :study_subject
	attr_protected :study_subject_id, :study_subject
	belongs_to :language

	delegate :is_other?, :to => :language, :allow_nil => true, :prefix => true

	validates_presence_of :other, :if => :language_is_other?

end
