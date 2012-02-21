#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module Identifier
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

#	==	requires
#	*	childid (unique)
#	*	study_subject_id (unique)
#	*	state_id_no ( unique )
#class Identifier < ActiveRecordShared

	#	Very cool that this doesn't stop factory girl from using them.
	#	it will stop the study_subject nested_attribute tests though
	attr_protected :studyid, :studyid_nohyphen, :studyid_intonly_nohyphen,
		:familyid, :childid, :subjectid, :patid, :orderno

#	include IdentifierValidations

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

	after_save :trigger_update_matching_study_subjects_reference_date, 
		:if => :matchingid_changed?

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

	#
	# logger levels are ... debug, info, warn, error, and fatal.
	#

	def trigger_update_matching_study_subjects_reference_date
		logger.debug "DEBUG: triggering_update_matching_study_subjects_reference_date from StudySubject:#{self.attributes['id']}"
		logger.debug "DEBUG: matchingid changed from:#{matchingid_was}:to:#{matchingid}"
		self.update_study_subjects_reference_date_matching(matchingid_was,matchingid)

#		if study_subject
#			logger.debug "DEBUG: study_subject:#{study_subject.id}"
#			study_subject.update_study_subjects_reference_date_matching(matchingid_was,matchingid)
#		else
#			# This should never happen, except in testing.
#			logger.warn "WARNING: Identifier(#{self.attributes['id']}) is missing study_subject"
#		end
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

end	#	class_eval
end	#	included
end	#	Identifier
