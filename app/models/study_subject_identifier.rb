#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectIdentifier
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	#	Very cool that this doesn't stop factory girl from using them.
	#	it will stop the study_subject nested_attribute tests though
	attr_protected :studyid, :studyid_nohyphen, :studyid_intonly_nohyphen,
		:familyid, :childid, :subjectid, :patid, :orderno

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
		#	NOTE ANY field that has a unique index in the database NEEDS
		#	to NOT be blank.  Multiple nils are acceptable in index,
		#	but multiple blanks are NOT.  Nilify ALL fields with
		#	unique indexes in the database.
		self.email = nil if email.blank?
		self.ssn = nil if ssn.blank?
		self.state_id_no = nil if state_id_no.blank?
		self.state_registrar_no = nil if state_registrar_no.blank?
		self.local_registrar_no = nil if local_registrar_no.blank?
		self.gbid = nil if gbid.blank?
		self.lab_no_wiemels = nil if lab_no_wiemels.blank?
		self.accession_no = nil if accession_no.blank?
		self.idno_wiemels = nil if idno_wiemels.blank?

		self.case_control_type = ( ( case_control_type.blank? 
			) ? nil : case_control_type.to_s.upcase )

		patid.try(:gsub!,/\D/,'')
		self.patid = sprintf("%04d",patid.to_i) unless patid.blank?

		matchingid.try(:gsub!,/\D/,'')
#	TODO add more tests for this (try with valid? method)
#puts "Matchingid before before validation:#{matchingid}"
		self.matchingid = sprintf("%06d",matchingid.to_i) unless matchingid.blank?
	end

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
		#	don't assign if given (familyid is currently protected)
		self.familyid  = subjectid if !is_mother? and familyid.blank?

		#	cases (patients): matchingID is the study_subject's own subjectID
		#	controls: matchingID is subjectID of the associated case 
		#		(like PatID in this respect).
		#	mothers: matchingID is subjectID of their own child's associated case. 
		#			That is, a mother's matchingID is the same as their child's. This 
		#			will become clearer when I provide specs for mother study_subject creation.
#	matchingid is manually set in some tests.  will need to setup for stubbing this.
		#	don't assign if given (matchingid is currently NOT protected)
		self.matchingid = subjectid if is_case? and matchingid.blank?
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
end	#	StudySubjectIdentifier
