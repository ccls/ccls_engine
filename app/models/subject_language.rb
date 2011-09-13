class SubjectLanguage < Shared
	belongs_to :study_subject
	belongs_to :language

	validates_presence_of :other,
		:if => :language_is_other?

protected
#	TODO delegate :is_other?

	def language_is_other?
		language.try(:is_other?)
	end

end
