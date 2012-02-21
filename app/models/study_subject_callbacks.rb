#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectCallbacks
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	before_validation :nullify_blank_fields

	after_create :add_new_subject_operational_event
	after_save   :add_subject_died_operational_event
	after_save   :trigger_setting_was_under_15_at_dx,
		:if => :dob_changed?

	#	All subjects are to have a CCLS project enrollment, so create after create.
	#	All subjects are to have this operational event, so create after create.
	#	I suspect that this'll be attached to the CCLS project enrollment.
	def add_new_subject_operational_event
		ccls_enrollment = enrollments.find_or_create_by_project_id(Project['ccls'].id)
		OperationalEvent.create!(
			:enrollment => ccls_enrollment,
			:operational_event_type => OperationalEventType['newSubject'],
			:occurred_on            => Date.today
		)
	end

	#	Add this if the vital status changes to deceased.
	#	I suspect that this'll be attached to the CCLS project enrollment.
	def add_subject_died_operational_event
		if( ( vital_status_id == VitalStatus['deceased'].id ) && 
				( vital_status_id_was != VitalStatus['deceased'].id ) )
			ccls_enrollment = enrollments.find_or_create_by_project_id(Project['ccls'].id)
			OperationalEvent.create!(
				:enrollment => ccls_enrollment,
				:operational_event_type => OperationalEventType['subjectDied'],
				:occurred_on            => Date.today
			)
		end
	end

	##
	#	triggered from patient and self
	def update_patient_was_under_15_at_dx
		#	due to the high probability that self, pii and patient will not
		#		yet be resolved, we have to get the associations manually.
#		my_pii     = Pii.find_by_study_subject_id(self.attributes['id'])
		my_patient = Patient.find_by_study_subject_id(self.attributes['id'])
#		if my_pii && my_pii.dob && my_patient && my_patient.admit_date &&
#				my_pii.dob.to_date != Date.parse('1/1/1900') &&
#				my_patient.admit_date.to_date != Date.parse('1/1/1900')
		if dob && my_patient && my_patient.admit_date &&
				dob.to_date != Date.parse('1/1/1900') &&
				my_patient.admit_date.to_date != Date.parse('1/1/1900')
			#
			#	update_all(updates, conditions = nil, options = {})
			#
			#		Updates all records with details given if they match a set of 
			#		conditions supplied, limits and order can also be supplied. 
			#		This method constructs a single SQL UPDATE statement and sends 
			#		it straight to the database. It does not instantiate the involved 
			#		models and it does not trigger Active Record callbacks. 
			#
#			Patient.update_all({
#				:was_under_15_at_dx => (((
#					my_patient.admit_date.to_date - my_pii.dob.to_date 
#					) / 365 ) < 15 )}, { :id => my_patient.id })

			#	crude and probably off by a couple days
			#	would be better to compare year, month then day
			was_under_15 = (((
#				my_patient.admit_date.to_date - my_pii.dob.to_date 
				my_patient.admit_date.to_date - dob.to_date 
				) / 365 ) < 15 ) ? YNDK[:yes] : YNDK[:no]
			Patient.update_all({ :was_under_15_at_dx => was_under_15 }, 
				{ :id => my_patient.id })
		end
		#	make sure we return true as is a callback
		true
	end

	##
	#	
	def update_study_subjects_reference_date_matching(*matchingids)
		logger.debug "DEBUG: In update_study_subjects_reference_date_matching(*matchingids)"
		logger.debug "DEBUG: update_study_subjects_reference_date_matching(#{matchingids.join(',')})"
#	if matchingids ~ [nil,12345]
#		identifier was either just created or matchingid added (compact as nil not needed)
#	if matchingids ~ [12345,nil]
#		matchingid was removed (compact as nil not needed)
#	if matchingids ~ [12345,54321]
#		matchingid was just changed
#	if matchingids ~ []
#		trigger came from Patient so need to find matchingid

		#	due to the high probability that self and identifier will not
		#		yet be resolved, we have to get the associations manually.
#		my_identifier = Identifier.find_by_study_subject_id(self.attributes['id'])
#		matchingids.compact.push(my_identifier.try(:matchingid)).uniq.each do |matchingid|
		matchingids.compact.push(matchingid).uniq.each do |mid|
			study_subject_ids = if( !mid.nil? )
#				Identifier.find_all_by_matchingid(mid).collect(&:study_subject_id)
				StudySubject.find_all_by_matchingid(mid).collect(&:id)
			else
				[id]
			end

			#	SHOULD only ever be 1 patient found amongst the study_subject_ids although there is
			#		currently no validation applied to the uniqueness of matchingid
			#	If there is more than one patient for a given matchingid, this'll just be wrong.

			matching_patient = Patient.find_by_study_subject_id(study_subject_ids)
			admit_date = matching_patient.try(:admit_date)

			logger.debug "DEBUG: calling StudySubject.update_study_subjects_reference_date(#{study_subject_ids.join(',')},#{admit_date})"
			StudySubject.update_study_subjects_reference_date( study_subject_ids, admit_date )
		end
		true
	end

protected

	#
	# logger levels are ... debug, info, warn, error, and fatal.
	#
	def trigger_setting_was_under_15_at_dx
		logger.debug "DEBUG: calling update_patient_was_under_15_at_dx from StudySubject:#{self.attributes['id']}"
		logger.debug "DEBUG: DOB changed from:#{dob_was}:to:#{dob}"
		update_patient_was_under_15_at_dx
	end

	def nullify_blank_fields
		#	An empty form field is blank, not NULL, to MySQL so ...
		self.email = nil if email.blank?
	end

	def self.update_study_subjects_reference_date(study_subject_ids,new_reference_date)
		logger.debug "DEBUG: In StudySubject.update_study_subjects_reference_date"
		logger.debug "DEBUG: update_study_subjects_reference_date(#{study_subject_ids.join(',')},#{new_reference_date})"
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (1,2)) 
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (NULL)) 
		unless study_subject_ids.empty?
			StudySubject.update_all(
				{:reference_date => new_reference_date },
				{ :id => study_subject_ids })
		end
	end

end	#	class_eval
end	#	included
end	#	StudySubjectCallbacks
__END__
