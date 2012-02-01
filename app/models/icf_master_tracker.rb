class IcfMasterTracker < ActiveRecordShared

	validates_presence_of   :Masterid
	validates_uniqueness_of :Masterid, :allow_blank => true

	belongs_to :study_subject

	before_save :attach_study_subject
	after_save  :update_models

	def attach_study_subject
		unless study_subject_id
			identifier = Identifier.find_by_icf_master_id(self.Masterid)
			if identifier and identifier.study_subject
				self.study_subject = identifier.study_subject
			end
		end
	end

	def update_models
#		if study_subject_id and dirty
#			add operational event with differences to study subject
#			update models
#		end
	end

end
