class SubjectLanguage < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :language
end
