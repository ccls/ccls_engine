class SubjectLanguage < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :language

	delegate :is_other?, :to => :language, :allow_nil => true, :prefix => true

	validates_presence_of :other, :if => :language_is_other?

end
