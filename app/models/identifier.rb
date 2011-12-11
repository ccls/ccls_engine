#	==	requires
#	*	childid (unique)
#	*	study_subject_id (unique)
#	*	state_id_no ( unique )
class Identifier < ActiveRecordShared

	belongs_to :study_subject

	#	Very cool that this doesn't stop factory girl from using them.
	#	it will stop the study_subject nested_attribute tests though
	attr_protected :studyid, :studyid_nohyphen, :studyid_intonly_nohyphen,
		:familyid, :childid, :subjectid, :patid, :orderno

	attr_protected :study_subject_id

	validates_uniqueness_of :studyid, :allow_nil => true

	validates_length_of :case_control_type, :is => 1, :allow_nil => true

#	TODO : add a validation for contents of orderno
#		won't have at creation

#	TODO I believe that subjectid is, or will be, a required field
#		it is auto-assigned so adding a validation that the user 
#		can't do anything about is a bad idea
#	validates_presence_of   :subjectid
#	validates_uniqueness_of :subjectid, :allow_nil => true

	validates_length_of     :ssn, :maximum => 250, :allow_nil => true
	validates_uniqueness_of :ssn, :allow_nil => true
	validates_format_of     :ssn, :with => /\A\d{3}-\d{2}-\d{4}\z/,
		:message => "should be formatted ###-##-####", :allow_nil => true

	with_options :allow_nil => true do |n|
		n.validates_uniqueness_of :icf_master_id
		n.validates_uniqueness_of :state_id_no
		n.validates_uniqueness_of :state_registrar_no
		n.validates_uniqueness_of :local_registrar_no
		n.validates_uniqueness_of	:gbid
		n.validates_uniqueness_of	:lab_no_wiemels
		n.validates_uniqueness_of	:accession_no
		n.validates_uniqueness_of	:idno_wiemels
	end

	with_options :allow_blank => true do |blank|
		blank.with_options :maximum => 250 do |o|
			o.validates_length_of :state_id_no
			o.validates_length_of :state_registrar_no
			o.validates_length_of :local_registrar_no
			o.validates_length_of :lab_no
			o.validates_length_of :related_childid
			o.validates_length_of :related_case_childid
		end
		blank.validates_length_of :childidwho, :maximum => 10
		blank.validates_length_of :newid, :maximum => 6
		blank.validates_length_of :gbid, :maximum => 26
		blank.validates_length_of :lab_no_wiemels, :maximum => 25
		blank.validates_length_of :idno_wiemels, :maximum => 10
		blank.validates_length_of :accession_no, :maximum => 25
		blank.validates_length_of :icf_master_id, :maximum => 9
	end


#
#	TODO why before_validation and not just before_save?
#			I don't think that any of these fields are really validated
#		wrong, subjectid is unique
#			patid is currently contextually unique
#			matchingid will be contextually unique
#
#	These values will be found or computed, so this may get weird

	before_validation :prepare_fields_for_validation
	before_create     :prepare_fields_for_creation
#	before_update     :prepare_fields_for_update

	after_save :trigger_update_matching_study_subjects_reference_date, 
		:if => :matchingid_changed?

	def is_mother?
		case_control_type.blank? or case_control_type == 'M'
	end

	def is_case?
		if study_subject 
			study_subject.is_case?   # primary check
		else
			case_control_type == 'C' # secondary check
		end
	end

	def is_control?
		!is_case? and !is_mother?
	end

protected

	#
	# logger levels are ... debug, info, warn, error, and fatal.
	#
	def trigger_update_matching_study_subjects_reference_date
		logger.debug "DEBUG: triggering_update_matching_study_subjects_reference_date from Identifier:#{self.attributes['id']}"
		logger.debug "DEBUG: matchingid changed from:#{matchingid_was}:to:#{matchingid}"
		if study_subject
			logger.debug "DEBUG: study_subject:#{study_subject.id}"
			study_subject.update_study_subjects_reference_date_matching(matchingid_was,matchingid)
		else
			# This should never happen, except in testing.
			logger.warn "WARNING: Identifier(#{self.attributes['id']}) is missing study_subject"
		end
	end

	def prepare_fields_for_validation
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
#	Right now, the demo won't work because the data has higher
#	values than expected so the created ids already exists.
#	I suppose that this failure is good as it forces the uniqueness
#	however, it raises a DATABASE error that the user can do nothing
#	about.
#	The imported data has a 14707 childid and 2375 patid while
#	the database was expecting less than 12000 and 2000.
#	

	#	made separate method so can be stubbed
	def get_next_childid
#	TODO I think that we may need to not use the Childid table and just
#		do something similar to subjectid.  Find the maximum existing
#		childid and increment it. (to_i first for when nil, blank or string)
#	This may work, but again, this will rely on the existance of the
#		data and that it won't be removed (or it may be duplicated)
#		Childid.create!.destroy.id
#		(Identifier.maximum(:childid).to_i||0) + 1
		Identifier.maximum(:childid).to_i + 1
	end

	#	made separate method so can be stubbed
	def get_next_patid
#	TODO I think that we may need to not use the Patid table and just
#		do something similar to subjectid.  Find the maximum existing
#		patid and increment it. (to_i first for when nil, blank or string)
#	This may work, but again, this will rely on the existance of the
#		data and that it won't be removed (or it may be duplicated)
#		Patid.create!.destroy.id
#		(Identifier.maximum(:patid).to_i||0) + 1
		Identifier.maximum(:patid).to_i + 1
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
		self.studyid = "#{patid}-#{case_control_type}-#{orderno}" if !is_mother? and studyid.blank?

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

#		prepare_fields_for_update
	end

#	def prepare_fields_for_update
#		#	ssn is unique in database so only one could be blank, but all can be nil
#		self.ssn = nil if ssn.blank?
#	end

	#	made separate method so can stub it in testing
	#	This only guarantees uniqueness before creation,
	#		but not at creation. This is NOT scalable.
	#	Fortunately, we won't be creating tons of study_subjects
	#		at the same time so this should not be an issue,
	#		however, when it fails, it will be confusing.	#	TODO
	#	How to rescue from ActiveRecord::RecordInvalid here?
	#		or would it be RecordNotSaved?
	def generate_subjectid
		subjectids = ( (1..999999).to_a - Identifier.find(:all,:select => 'subjectid'
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

end
