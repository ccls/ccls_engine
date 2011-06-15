#	==	requires
#	*	childid (unique)
#	*	subject_id (unique)
#	*	state_id_no ( unique )
class Identifier < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'

	#	Very cool that this doesn't stop factory girl from using them.
	#	it will stop the subject nested_attribute tests though
	attr_protected :studyid, :studyid_nohyphen, :studyid_intonly_nohyphen,
		:familyid, :childid, :subjectid, :patid, :orderno


#
#	TODO - Don't validate anything that the creating user can't do anything about.
#

	##	TODO - find a way to do this
	#	because subject accepts_nested_attributes for pii 
	#	we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	attr_protected :study_subject_id
	validates_presence_of   :subject,          :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true
#	validates_uniqueness_of :study_subject_id, :on => :update

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the subject creation too if using nested attributes.
	before_create :ensure_presence_and_uniqueness_of_study_subject_id

#	validates_presence_of   :orderno
#	validates_presence_of   :patid
	validates_presence_of   :case_control_type		#	apparently could be null for mother's
	validates_length_of     :case_control_type, :is => 1
#	validates_uniqueness_of :patid, :scope => [:orderno,:case_control_type]


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
	validates_uniqueness_of :ssn, :allow_nil => true
#	validates_format_of     :ssn, :with => /\A\d{9}\z/

#	TODO I believe that subjectid is, or will be, a required field
#	validates_presence_of   :subjectid
#	validates_uniqueness_of :subjectid, :allow_nil => true

	validates_uniqueness_of :icf_master_id, :allow_nil => true

#	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no, :allow_nil => true

	with_options :allow_blank => true do |blank|
		blank.with_options :maximum => 250 do |o|
			o.validates_length_of :state_id_no
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
#
#	before_validation :pad_zeros_to_patid
	before_validation :pad_zeros_to_matchingid

	#	FYI: before_validation will be called before before_validation_on_create
#	before_validation_on_create :prepare_fields_for_validation_on_create
	before_validation :prepare_fields_for_validation
	before_create     :prepare_fields_for_creation
	before_update     :prepare_fields_for_updation
#	#	FYI: before_save will be called before before_create
#	before_save       :prepare_fields_for_save

	after_save :trigger_update_matching_subjects_reference_date, 
		:if => :matchingid_changed?

protected

	def trigger_update_matching_subjects_reference_date
		subject.update_subjects_reference_date_matching(matchingid_was,matchingid)
	end

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the subject creation too if using nested attributes.
#	this is probably a bad idea as the user can't do anything about it anyway
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
		self.state_id_no = nil if state_id_no.blank?
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
#puts "In prepare_fields_for_creation"

		#	The only subjects that don't get a childID are mother subjects.
		#	mother's will with have null or 'M' as case_control_type
		self.childid = get_next_childid unless is_mother?

		self.patid = sprintf("%04d",get_next_patid.to_i) if is_case?

		self.orderno = 0 if is_case?

		#	perhaps put in an after_save with an update_attribute(s)
		#	and simply generate a new one until all is well
		self.subjectid = generate_subjectid

		#	cases and controls: their own subjectID is also their familyID.
		#	mothers: their child's subjectID is their familyID. That is, 
		#					a mother and her child have identical familyIDs.
#	how to get child?  given?
#		self.familyid  = subjectid						#	TODO : this won't be true for mother's
#	this won't work here unless passed child's subjectid
		self.familyid  = ( ( is_mother? ) ? nil : subjectid )
#		self.familyid  = if is_mother?
#			nil
#		else
#			subjectid
#		end

		#	cases (patients): matchingID is the subject's own subjectID
		#	controls: matchingID is subjectID of the associated case (like PatID in this respect).
#	how to get associated case?  given?
		#	mothers: matchingID is subjectID of their own child's associated case. 
		#			That is, a mother's matchingID is the same as their child's. This 
		#			will become clearer when I provide specs for mother subject creation.
#	matchingid is manually set in some tests.  will need to setup for stubbing this.
		self.matchingid = subjectid if is_case?
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

		self.studyid = "#{patid}-#{case_control_type}-#{orderno}"
		self.studyid_nohyphen = "#{patid}#{case_control_type}#{orderno}"
		#	replace case_control_type with 0
		#		0 may only be for C, so this may need updated
		self.studyid_intonly_nohyphen = "#{patid}" <<
			"#{(is_case?) ? 0 : case_control_type}#{orderno}"

	end

#	FYI: before_save is called before before_create
#	def prepare_fields_for_save
#puts "In prepare_fields_for_save"
#	end

	#	made separate method so can stub it in testing
	#	This only guarantees uniqueness before creation,
	#		but not at creation. This is NOT scalable.
	#	Fortunately, we won't be creating tons of subjects
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


	#	Pad leading zeroes to matchingid
	def pad_zeros_to_matchingid
		matchingid.try(:gsub!,/\D/,'')
#	TODO add more tests for this (try with valid? method)
#puts "Matchingid before before validation:#{matchingid}"
		self.matchingid = sprintf("%06d",matchingid.to_i) unless matchingid.blank?
#puts "Matchingid after before validation:#{matchingid}"
	end 

	#	Pad leading zeroes to patid
	def pad_zeros_to_patid
		patid.try(:gsub!,/\D/,'') #unless patid.nil?
#	TODO add more tests for this (try with valid? method)
		self.patid = sprintf("%04d",patid.to_i) unless patid.blank?
	end 

	def is_mother?
		case_control_type.blank? or case_control_type == 'M'
	end

	def is_case?
		case_control_type == 'C'
	end

	def is_control?
		!is_case? and !is_mother?
	end

end
