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


	after_create :add_new_subject_operational_event
	after_save   :add_subject_died_operational_event
	after_save   :trigger_setting_was_under_15_at_dx,
		:if => :dob_changed?
	after_save :trigger_update_matching_study_subjects_reference_date, 
		:if => :matchingid_changed?

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
		#	due to the high probability that self and patient will not
		#		yet be resolved, we have to get the associations manually.
		my_patient = Patient.find_by_study_subject_id(self.attributes['id'])
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
#				StudySubject.find_all_by_matchingid(mid).collect(&:id)
				self.class.find_all_by_matchingid(mid).collect(&:id)
			else
				[id]
			end

			#	SHOULD only ever be 1 patient found amongst the study_subject_ids although there is
			#		currently no validation applied to the uniqueness of matchingid
			#	If there is more than one patient for a given matchingid, this'll just be wrong.

			matching_patient = Patient.find_by_study_subject_id(study_subject_ids)
			admit_date = matching_patient.try(:admit_date)

			logger.debug "DEBUG: calling StudySubject.update_study_subjects_reference_date(#{study_subject_ids.join(',')},#{admit_date})"
#			StudySubject.update_study_subjects_reference_date( study_subject_ids, admit_date )
			self.class.update_study_subjects_reference_date( study_subject_ids, admit_date )
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

	def trigger_update_matching_study_subjects_reference_date
		logger.debug "DEBUG: triggering_update_matching_study_subjects_reference_date from StudySubject:#{self.attributes['id']}"
		logger.debug "DEBUG: matchingid changed from:#{matchingid_was}:to:#{matchingid}"
		self.update_study_subjects_reference_date_matching(matchingid_was,matchingid)
	end

	def self.update_study_subjects_reference_date(study_subject_ids,new_reference_date)
		logger.debug "DEBUG: In StudySubject.update_study_subjects_reference_date"
		logger.debug "DEBUG: update_study_subjects_reference_date(#{study_subject_ids.join(',')},#{new_reference_date})"
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (1,2)) 
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (NULL)) 
		unless study_subject_ids.empty?
#			StudySubject.update_all(
			self.update_all(
				{:reference_date => new_reference_date },
				{ :id => study_subject_ids })
		end
	end

end	#	class_eval
end	#	included
end	#	StudySubjectCallbacks
__END__


stuff from identifier


	before_validation :prepare_fields_for_validation
	before_create     :prepare_fields_for_creation

	def self.find_all_by_studyid_or_icf_master_id(studyid,icf_master_id)
#	if decide to use LIKE, will need to NOT include nils so
#	will need to add some conditions to the conditions.
		self.find( :all, 
			:conditions => [
				"studyid = :studyid OR icf_master_id = :icf_master_id",
				{ :studyid => studyid, :icf_master_id => icf_master_id }
			]
		)
	end

protected




	def prepare_fields_for_validation
		# An empty form field is blank, not NULL, to MySQL so ...
		self.email = nil if email.blank?

		#	ssn is unique in database so only one could be blank, but all can be nil
		self.ssn = nil if ssn.blank?

		self.case_control_type = ( ( case_control_type.blank? 
			) ? nil : case_control_type.to_s.upcase )

		#	NOTE ANY field that has a unique index in the database NEEDS
		#	to NOT be blank.  Multiple nils are acceptable in index,
		#	but multiple blanks are NOT.  Nilify ALL fields with
		#	unique indexes in the database.
		self.state_id_no = nil if state_id_no.blank?
		self.state_registrar_no = nil if state_registrar_no.blank?
		self.local_registrar_no = nil if local_registrar_no.blank?
		self.gbid = nil if gbid.blank?
		self.lab_no_wiemels = nil if lab_no_wiemels.blank?
		self.accession_no = nil if accession_no.blank?
		self.idno_wiemels = nil if idno_wiemels.blank?

		patid.try(:gsub!,/\D/,'')
		self.patid = sprintf("%04d",patid.to_i) unless patid.blank?

		matchingid.try(:gsub!,/\D/,'')
#	TODO add more tests for this (try with valid? method)
#puts "Matchingid before before validation:#{matchingid}"
		self.matchingid = sprintf("%06d",matchingid.to_i) unless matchingid.blank?
	end

#	TODO	the new technique of basing the next on the maximum current works, but will require the existing data (at least the highs)
#	The techniques for generating childid and patid are just not
#	sustainable.  I do not have any immediate idea for a better
#	approach, but I can already see that this will cause problems
#	unless ALL of the data is imported and the correct initial
#	AUTO_INCREMENT value is set.  This will make the application
#	database dependent, which I think is a bad idea.
#	

	#	made separate method so can be stubbed
	def get_next_childid
		self.class.maximum(:childid).to_i + 1
	end

	#	made separate method so can be stubbed
	def get_next_patid
		self.class.maximum(:patid).to_i + 1
#
#	What happens if/when this goes over 4 digits? 
#	The database field is only 4 chars.
#
	end

	#	fields made from fields that WON'T change go here
	def prepare_fields_for_creation

		#	don't assign if given or is mother (childid is currently protected)
		self.childid = get_next_childid if !is_mother? and childid.blank?

		#	don't assign if given or is not case (patid is currently protected)
		self.patid = sprintf("%04d",get_next_patid.to_i) if is_case? and patid.blank?

#	should move this from pre validation to here for ALL subjects.
#		patid.try(:gsub!,/\D/,'')
#		self.patid = sprintf("%04d",patid.to_i) unless patid.blank?

		#	don't assign if given or is not case (orderno is currently protected)
		self.orderno = 0 if is_case? and orderno.blank?

		#	don't assign if given or is mother (studyid is currently protected)
		#	or if can't make complete studyid
		if !is_mother? and studyid.blank? and
				!patid.blank? and !case_control_type.blank? and !orderno.blank?
			self.studyid = "#{patid}-#{case_control_type}-#{orderno}" 
		end

		#	perhaps put in an after_save with an update_attribute(s)
		#	and simply generate a new one until all is well
		#	don't assign if given (subjectid is currently protected)
		self.subjectid = generate_subjectid if subjectid.blank?

		#	cases and controls: their own subjectID is also their familyID.
		#	mothers: their child's subjectID is their familyID. That is, 
		#					a mother and her child have identical familyIDs.
#	TODO auto copying of familyid and matchingid???
#	how to get child?  given?
#		self.familyid  = subjectid						#	TODO : this won't be true for mother's
#	this won't work here unless passed child's subjectid
#		self.familyid  = ( ( is_mother? ) ? nil : subjectid )
		#	don't assign if given (familyid is currently protected)
#	TODO what about is_father?
		self.familyid  = subjectid if !is_mother? and familyid.blank?
#		self.familyid  = if is_mother?
#			nil
#		else
#			subjectid
#		end

		#	cases (patients): matchingID is the study_subject's own subjectID
		#	controls: matchingID is subjectID of the associated case (like PatID in this respect).
# TODO	how to get associated case?  given?
		#	mothers: matchingID is subjectID of their own child's associated case. 
		#			That is, a mother's matchingID is the same as their child's. This 
		#			will become clearer when I provide specs for mother study_subject creation.
#	matchingid is manually set in some tests.  will need to setup for stubbing this.
		#	don't assign if given (matchingid is currently NOT protected)
		self.matchingid = subjectid if is_case? and matchingid.blank?
#		self.matchingid = case case_control_type
#			when 'C' then subjectid
#			else nil
#		end

	end

	#	made separate method so can stub it in testing
	#	This only guarantees uniqueness before creation,
	#		but not at creation. This is NOT scalable.
	#	Fortunately, we won't be creating tons of study_subjects
	#		at the same time so this should not be an issue,
	#		however, when it fails, it will be confusing.	#	TODO
	#	How to rescue from ActiveRecord::RecordInvalid here?
	#		or would it be RecordNotSaved?
#
#	Perhaps treat subjectid like icf_master_id?
#	Create a table with all of the possible 
#		subjectid ... (1..999999)
#		study_subject_id
#		assigned_on
#	Then select a random unassigned one?
#	Would this be faster?
#
	def generate_subjectid
#		subjectids = ( (1..999999).to_a - Identifier.find(:all,:select => 'subjectid'
		subjectids = ( (1..999999).to_a - self.class.find(:all,:select => 'subjectid'
			).collect(&:subjectid).collect(&:to_i) )
		#	CANNOT have leading 0' as it thinks its octal and converts
		#>> sprintf("%06d","0001234")
		#=> "000668"
		#
		# CANNOT have leading 0's and include and 8 or 9 as it thinks its octal
		# so convert back to Integer first
		#>> sprintf("%06d","0001280")
		#ArgumentError: invalid value for Integer: "0001280"
		# from (irb):24:in `sprintf'
		# from (irb):24
		sprintf("%06d",subjectids[rand(subjectids.length)].to_i)
	end

