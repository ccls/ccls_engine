#	==	requires
#	*	childid (unique)
#	*	subject_id (unique)
#	*	state_id_no ( unique )
class Identifier < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'

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

#	TODO
#	At some point gonna need something like ...
#	before_validation :set_childid
#	before_validation :set_patid
#	but this will generate patid and childid at EVERY validation,
#	NOT every create which will create gaps
#	HOWEVER, validating fields that the user cannot modify can 
#		and will generate error messages that the user cannot fix (bad idea)
#		so shouldn't do ANY validation of childid, patid, subjectid, orderno, 
#		case_control_type, study_subject_id??, icf_master_id
#	MUST WAIT UNTIL ALL SUBJECTS ARE IMPORTED!
#	Don't want to overwrite existing data!

	validates_presence_of   :childid
	validates_uniqueness_of :childid

	validates_presence_of   :orderno
	validates_presence_of   :patid
#	pointless
#	validates_length_of     :patid, :maximum => 4
	validates_presence_of   :case_control_type
	validates_uniqueness_of :patid, :scope => [:orderno,:case_control_type]


#	TODO : add a validation for contents of orderno
#	TODO : add a validation for contents of case_control_type

#
#	TODO : simplify with with_options block
#

#	validates_presence_of   :ssn
	validates_uniqueness_of :ssn, :allow_nil => true
#	validates_format_of     :ssn, :with => /\A\d{9}\z/

#	TODO I believe that subjectid is a required field
#	validates_presence_of   :subjectid
	validates_uniqueness_of :subjectid, :allow_nil => true

	validates_uniqueness_of :icf_master_id, :allow_nil => true

#	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no, :allow_nil => true

	with_options :allow_blank => true do |blank|
		blank.with_options :maximum => 250 do |o|
			o.validates_length_of :state_id_no
			o.validates_length_of :case_control_type
			o.validates_length_of :lab_no
			o.validates_length_of :related_childid
			o.validates_length_of :related_case_childid
			o.validates_length_of :ssn
		end
		blank.validates_length_of :childidwho, :maximum => 10
		blank.validates_length_of :studyid, :maximum => 14
		blank.validates_length_of :newid, :maximum => 6
		blank.validates_length_of :gbid, :maximum => 26
		blank.validates_length_of :lab_no_wiemels, :maximum => 25
		blank.validates_length_of :idno_wiemels, :maximum => 10
		blank.validates_length_of :accession_no, :maximum => 25
		blank.validates_length_of :studyid_nohyphen, :maximum => 12
		blank.validates_length_of :studyid_intonly_nohyphen, :maximum => 12
		blank.validates_length_of :icf_master_id, :maximum => 9
	end


#
#	TODO why before_validation and not just before_save?
#			I don't think that any of these fields are really validated
#
	before_validation :pad_zeros_to_patid
	before_validation :pad_zeros_to_subjectid
	before_validation :pad_zeros_to_matchingid
	before_validation :format_ssn
#
#	TODO actually the nullify fields NEED to be before validation as they are unique
#
	before_validation :nullify_subjectid
	before_validation :nullify_ssn
	before_validation :nullify_state_id_no

#
#	TODO perhaps just a before_save :set_computed_fields and include those above
#
	before_save :set_studyids

	after_save :trigger_update_matching_subjects_reference_date, 
		:if => :matchingid_changed?

protected

	def trigger_update_matching_subjects_reference_date
#		puts "triggering_update_matching_subjects_reference_date from Identifier"
#		puts matchingid_was
#		puts "matchingid changed from:#{matchingid_was}:to:#{matchingid}"
#		subject.update_matching_subjects_reference_date
#	matchingid_was is only really important if this subject is the patient
#	if have 2 groups of subjects with matchingids and 'move' the patient from
#	one to the other, the initial subjects' reference_dates should be nullified when
#	updated as there will no longer be a patient.admit_date.  The new subjects'
#	reference_dates will update as normal
#	don't send a blank one (matchingid_was is blank on create) deal with it in subjects
#		subject.update_subjects_reference_date_matching(*[matchingid_was,matchingid].compact)
#		subject.update_subjects_reference_date_matching(matchingid_was,matchingid)
#puts "Matchingid after_save:#{matchingid}"
		subject.update_subjects_reference_date_matching(matchingid_was,matchingid)
	end

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the subject creation too if using nested attributes.
	def ensure_presence_and_uniqueness_of_study_subject_id
		if study_subject_id.blank?
			errors.add(:study_subject_id, :blank )
			return false
#		elsif Identifier.exists?(:study_subject_id => study_subject_id)
#			errors.add(:study_subject_id, :taken )
#			return false
		end
	end

	def set_studyids
		self.case_control_type.upcase!
		self.studyid = "#{patid}-#{case_control_type}-#{orderno}"
		self.studyid_nohyphen = "#{patid}#{case_control_type}#{orderno}"
		#	replace case_control_type with 0
		#		0 may only be for C, so this may need updated
		self.studyid_intonly_nohyphen = "#{patid}" <<
			"#{(case_control_type == 'C') ? 0 : case_control_type}#{orderno}"
	end

	#	Strips out all non-numeric characters
	def format_ssn
#
#	TODO this shouldn't work but seems to.  The gsub! shouldn't be 
#		updating the ssn due to the to_s method in between
#	TODO add more tests for this (try with valid? method)
#
#		self.ssn.to_s.gsub!(/\D/,'')
#		self.ssn = ssn.to_s.gsub!(/\D/,'')
		self.ssn = ssn.to_s.gsub(/\D/,'')
	end

	#	Pad leading zeroes to subjectid
	def pad_zeros_to_subjectid
		#>> sprintf("%06d","0001234")
		#=> "000668"
		#>> sprintf("%06d","0001239")
		#ArgumentError: invalid value for Integer: "0001239"
		# from (irb):22:in `sprintf'
		# from (irb):22
		#>> sprintf("%06d","0001238")
		#ArgumentError: invalid value for Integer: "0001238"
		# from (irb):23:in `sprintf'
		# from (irb):23
		#>> sprintf("%06d","0001280")
		#ArgumentError: invalid value for Integer: "0001280"
		# from (irb):24:in `sprintf'
		# from (irb):24
		#	 
		# CANNOT have leading 0's and include and 8 or 9 as it thinks its octal
		# so convert back to Integer first
		subjectid.try(:gsub!,/\D/,'')
#	TODO add more tests for this (try with valid? method)
		self.subjectid = sprintf("%06d",subjectid.to_i) unless subjectid.blank?
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
		patid.try(:gsub!,/\D/,'')
#	TODO add more tests for this (try with valid? method)
		self.patid = sprintf("%04d",patid.to_i) unless patid.blank?
	end 

	#	Pad leading zeroes to familyid
#	no longer used I believe
#	def pad_zeros_to_familyid
#		familyid.try(:gsub!,/\D/,'')
#		self.familyid = sprintf("%06d",familyid.to_i) unless familyid.blank?
#	end 

	def nullify_subjectid
		#	mysql allows multiple NULLs in unique column
		#	but NOT multiple blanks
#	TODO add more tests for this (try with valid? method)
		self.subjectid = nil if subjectid.blank?
	end

	def nullify_ssn
		#	mysql allows multiple NULLs in unique column
		#	but NOT multiple blanks
#	TODO add more tests for this (try with valid? method)
		self.ssn = nil if ssn.blank?
	end

	def nullify_state_id_no
		#	mysql allows multiple NULLs in unique column
		#	but NOT multiple blanks
#	TODO add more tests for this (try with valid? method)
		self.state_id_no = nil if state_id_no.blank?
	end

#	TODO comment out 'til ready to use 'em
#
#	some of these are going to be autogenerated.
#	may have to generate them from within subject though.
#	attr_protected :patid, :childid, :subjectid, :matchingid, :familyid, 
#		:case_control_type, :orderno
#
#	#	Use the ! so that an exception is raised on failure
#	def generate_next_patid
#		should be able to stub Patid.id to return number so can test
#		Patid.create!.destroy.id
#	end
#
#	#	Use the ! so that an exception is raised on failure
#	def generate_next_childid
#		should be able to stub Childid.id to return number so can test
#		Childid.create!.destroy.id
#	end
#
#	def find_or_generate_subjectid
#		apparently expected to be randomly generated AND unique
#	end
#
#	def find_or_generate_matchingid
#	end
#
#	def find_or_generate_familyid
#	end
#
#	def find_or_generate_orderno
#		I think that this is 0 for cases and 1.. for matching controls
#		( define creation of a matching control )
#	end
#
#	def generate_icf_master_id		#	actually more of a select than a generate
#	end

end
