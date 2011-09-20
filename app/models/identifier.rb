#	==	requires
#	*	childid (unique)
#	*	study_subject_id (unique)
#	*	state_id_no ( unique )
class Identifier < Shared
	belongs_to :study_subject

	#	Very cool that this doesn't stop factory girl from using them.
	#	it will stop the study_subject nested_attribute tests though
	attr_protected :studyid, :studyid_nohyphen, :studyid_intonly_nohyphen,
		:familyid, :childid, :subjectid, :patid, :orderno

#
#	TODO - Don't validate anything that the creating user can't do anything about.
#

	##	TODO - find a better way to do this
	#	because study_subject accepts_nested_attributes for identifer
	#	we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	attr_protected          :study_subject_id
	validates_presence_of   :study_subject,    :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true
	#
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the study_subject creation too if using nested attributes.
	#	I don't know that this is ever really an even possible issue
	#	as there is no way to directly create one.
	before_create :ensure_presence_and_uniqueness_of_study_subject_id


	validates_presence_of   :case_control_type		#	TODO apparently could be null for mother's
	validates_length_of     :case_control_type, :is => 1


#	TODO : add a validation for contents of orderno
#		won't have at creation

#	actually, it can also be F, B, T and possibly M
#	and the integers will probably only be 4, 5 or 6
#	validates_inclusion_of :case_control_type, :in => ['C',*(1..9).collect(&:to_s) ]
		#	case_control_type is only 1 digit!  can only be 'C' or integers
		#>> ['C', *(1..9).collect(&:to_s) ]
		#=> ["C", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
		#	can't be 0 as case is 0 in studyid_intonly_nohyphen

#	validates_presence_of   :ssn
#	validates_format_of     :ssn, :with => /\A\d{9}\z/

#	TODO I believe that subjectid is, or will be, a required field
#	validates_presence_of   :subjectid
#	validates_uniqueness_of :subjectid, :allow_nil => true

	with_options :allow_nil => true do |n|
		n.validates_uniqueness_of :ssn
		n.validates_uniqueness_of :icf_master_id
		n.validates_uniqueness_of :state_id_no
		n.validates_uniqueness_of :state_registrar_no
		n.validates_uniqueness_of :local_registrar_no
		n.validates_uniqueness_of	:gbid
		n.validates_uniqueness_of	:lab_no_wiemels
		n.validates_uniqueness_of	:accession_no
		n.validates_uniqueness_of	:hospital_no
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
			o.validates_length_of :ssn
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

#	before_validation :pad_zeros_to_patid
#	before_validation :pad_zeros_to_matchingid

	#	FYI: before_validation will be called before before_validation_on_create
#	before_validation_on_create :prepare_fields_for_validation_on_create
	before_validation :prepare_fields_for_validation
	before_create     :prepare_fields_for_creation
	before_update     :prepare_fields_for_updation
#	#	FYI: before_save will be called before before_create
#	before_save       :prepare_fields_for_save

	after_save :trigger_update_matching_study_subjects_reference_date, 
		:if => :matchingid_changed?

	def is_mother?
		case_control_type.blank? or case_control_type == 'M'
	end

	def is_case?
		if study_subject 
			study_subject.is_case?
		else
			case_control_type == 'C'
		end
	end

	def is_control?
		!is_case? and !is_mother?
	end

	def studyid
		@studyid || "#{patid}-#{case_control_type}-#{orderno}"
	end

	def studyid_nohyphen
		@studyid_nohyphen || "#{patid}#{case_control_type}#{orderno}"
	end

	def studyid_intonly_nohyphen
		@studyid_intonly_nohyphen || "#{patid}" <<
			"#{(is_case?) ? 0 : case_control_type}#{orderno}"
	end

protected

	def trigger_update_matching_study_subjects_reference_date
		study_subject.update_study_subjects_reference_date_matching(matchingid_was,matchingid)
	end

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the study_subject creation too if using nested attributes.
#	this is probably a bad idea as the user can't do anything about it anyway
#	there is no uniqueness check anymore
	def ensure_presence_and_uniqueness_of_study_subject_id
		if study_subject_id.blank?
			errors.add(:study_subject_id, :blank )
			return false
#		elsif Identifier.exists?(:study_subject_id => study_subject_id)
#			errors.add(:study_subject_id, :taken )
#			return false
		end
	end

#	#	before_validation_on_create is AFTER before_validation
#	def prepare_fields_for_validation_on_create
#		self.patid = Patid.create!.destroy.id if patid.blank?
#	end

	def prepare_fields_for_validation
		self.case_control_type = case_control_type.to_s.upcase
		self.ssn = ( ( ssn.blank? ) ? nil : ssn.to_s.gsub(/\D/,'') )
		#	ANY field that has a unique index in the database NEEDS
		#	to NOT be blank.  Multiple nils are acceptable in index,
		#	but multiple blanks are NOT.  Nilify ALL fields with
		#	unique indexes in the database.
		self.state_id_no = nil if state_id_no.blank?
		self.state_registrar_no = nil if state_registrar_no.blank?
		self.local_registrar_no = nil if local_registrar_no.blank?
		self.gbid = nil if gbid.blank?
		self.lab_no_wiemels = nil if lab_no_wiemels.blank?
		self.accession_no = nil if accession_no.blank?
		self.hospital_no = nil if hospital_no.blank?
		self.idno_wiemels = nil if idno_wiemels.blank?

		patid.try(:gsub!,/\D/,'') #unless patid.nil?
		self.patid = sprintf("%04d",patid.to_i) unless patid.blank?
		matchingid.try(:gsub!,/\D/,'')
#	TODO add more tests for this (try with valid? method)
#puts "Matchingid before before validation:#{matchingid}"
		self.matchingid = sprintf("%06d",matchingid.to_i) unless matchingid.blank?
	end

	#	made separate method so can be stubbed
	def get_next_childid
		Childid.create!.destroy.id
	end

	#	made separate method so can be stubbed
	def get_next_patid
		Patid.create!.destroy.id
	end

	#	fields made from fields that WON'T change go here
	def prepare_fields_for_creation

		#	don't assign if given (childid is currently protected)
		self.childid = get_next_childid if !is_mother? and childid.blank?

		#	don't assign if given (patid is currently protected)
		self.patid = sprintf("%04d",get_next_patid.to_i) if is_case? and patid.blank?

		#	don't assign if given (orderno is currently protected)
		self.orderno = 0 if is_case? and orderno.blank?

		#	perhaps put in an after_save with an update_attribute(s)
		#	and simply generate a new one until all is well
		#	don't assign if given (subjectid is currently protected)
		self.subjectid = generate_subjectid if subjectid.blank?

		#	cases and controls: their own subjectID is also their familyID.
		#	mothers: their child's subjectID is their familyID. That is, 
		#					a mother and her child have identical familyIDs.
#	how to get child?  given?
#		self.familyid  = subjectid						#	TODO : this won't be true for mother's
#	this won't work here unless passed child's subjectid
#		self.familyid  = ( ( is_mother? ) ? nil : subjectid )
		#	don't assign if given (familyid is currently protected)
		self.familyid  = subjectid if !is_mother? and familyid.blank?
#		self.familyid  = if is_mother?
#			nil
#		else
#			subjectid
#		end

		#	cases (patients): matchingID is the study_subject's own subjectID
		#	controls: matchingID is subjectID of the associated case (like PatID in this respect).
#	how to get associated case?  given?
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

		prepare_fields_for_updation
	end

	def prepare_fields_for_updation
#puts "In prepare_fields_for_updation"

#	TODO orderno will be computed
#	need patid before can create studyid
#	need orderno before can create studyid

#	for controls, these values won't be known at creation
#	so we need to continue to update them

#		self.studyid = "#{patid}-#{case_control_type}-#{orderno}"
#		self.studyid_nohyphen = "#{patid}#{case_control_type}#{orderno}"
#		#	replace case_control_type with 0
#		#		0 may only be for C, so this may need updated
#		self.studyid_intonly_nohyphen = "#{patid}" <<
#			"#{(is_case?) ? 0 : case_control_type}#{orderno}"

	end

#	FYI: before_save is called before before_create
#	def prepare_fields_for_save
#puts "In prepare_fields_for_save"
#	end

	#	made separate method so can stub it in testing
	#	This only guarantees uniqueness before creation,
	#		but not at creation. This is NOT scalable.
	#	Fortunately, we won't be creating tons of study_subjects
	#		at the same time so this should not be an issue.
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
