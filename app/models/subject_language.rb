class SubjectLanguage < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :language

	validates_presence_of :other,
		:if => :language_is_other?

protected

	def language_is_other?
		language.try(:is_other?)
	end

end
