#	==	requires
#	*	childid (unique)
#	*	subject_id (unique)
#	*	state_id_no ( unique )
class Identifier < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'

	#	Very cool that this doesn't stop factory girl from using them.
	#	it will stop the subject nested_attribute tests though
	attr_protected :studyid, :studyid_nohyphen, :studyid_intonly_nohyphen,
		:familyid, :childid, :subjectid	#, :matchingid	#, :patid


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

#	validates_presence_of   :childid
#	validates_uniqueness_of :childid	#, :allow_nil => true

	validates_presence_of   :orderno
	validates_presence_of   :patid
#	pointless
#	validates_length_of     :patid, :maximum => 4
	validates_presence_of   :case_control_type
	validates_length_of     :case_control_type, :is => 1
	validates_uniqueness_of :patid, :scope => [:orderno,:case_control_type]


#	TODO : add a validation for contents of orderno

#	actually, it can also be F, B and possible M
#	and the integers will probably only be 4, 5 or 6
#	validates_inclusion_of :case_control_type, :in => ['C',*(1..9).collect(&:to_s) ]
		#	case_control_type is only 1 digit!  can only be 'C' or integers
		#>> ['C', *(1..9).collect(&:to_s) ]
		#=> ["C", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
		#	can't be 0 as case is 0 in studyid_intonly_nohyphen

#
#	TODO : simplify with with_options block
#

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
#		blank.validates_length_of :case_control_type, :maximum => 1
		blank.validates_length_of :childidwho, :maximum => 10
#		blank.validates_length_of :studyid, :maximum => 14
		blank.validates_length_of :newid, :maximum => 6
		blank.validates_length_of :gbid, :maximum => 26
		blank.validates_length_of :lab_no_wiemels, :maximum => 25
		blank.validates_length_of :idno_wiemels, :maximum => 10
		blank.validates_length_of :accession_no, :maximum => 25
#		blank.validates_length_of :studyid_nohyphen, :maximum => 12
#		blank.validates_length_of :studyid_intonly_nohyphen, :maximum => 12
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
	before_validation :pad_zeros_to_patid
#	before_validation :pad_zeros_to_subjectid
	before_validation :pad_zeros_to_matchingid

#	doesn't just validate on create....
#	before_validation :prepare_fields_for_validation_on_create, :on => :create
#	calls AFTER normal before_validation????
	before_validation_on_create :prepare_fields_for_validation_on_create
	before_validation :prepare_fields_for_validation
	before_create     :prepare_fields_for_creation

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
#	this is probably a bad idea as the user can't do anything about it
	def ensure_presence_and_uniqueness_of_study_subject_id
		if study_subject_id.blank?
			errors.add(:study_subject_id, :blank )
			return false
#		elsif Identifier.exists?(:study_subject_id => study_subject_id)
#			errors.add(:study_subject_id, :taken )
#			return false
		end
	end

	#	before_validation_on_create is AFTER before_validation
	def prepare_fields_for_validation_on_create
#		self.patid = Patid.create!.destroy.id if patid.blank?
	end

	def prepare_fields_for_validation
		self.case_control_type = case_control_type.to_s.upcase
		self.ssn = ( ( ssn.blank? ) ? nil : ssn.to_s.gsub(/\D/,'') )
		self.state_id_no = nil if state_id_no.blank?
	end

	#	fields made from fields that WON'T change go here
#	I don't know that all of the needed info will be available at creation of controls and mothers
#	so some of this may need to be moved to "prepare_fields_for_updation"
	def prepare_fields_for_creation
#	TODO orderno will be computed
#	TODO create patid and childid stuff here

#	need patid before can create studyid
#	need orderno before can create studyid

		self.studyid = "#{patid}-#{case_control_type}-#{orderno}"
		self.studyid_nohyphen = "#{patid}#{case_control_type}#{orderno}"
		#	replace case_control_type with 0
		#		0 may only be for C, so this may need updated
		self.studyid_intonly_nohyphen = "#{patid}" <<
			"#{(case_control_type == 'C') ? 0 : case_control_type}#{orderno}"

		#	The only subjects that don't get a childID are mother subjects.
		#	mother's will with have null or 'M' as case_control_type
		self.childid = Childid.create!.destroy.id unless case_control_type.blank?

		#	perhaps put in an after_save with an update_attribute(s)
		#	and simply generate a new one until all is well
		self.subjectid = generate_subjectid

		#	cases and controls: their own subjectID is also their familyID.
		#	mothers: their child's subjectID is their familyID. That is, 
		#					a mother and her child have identical familyIDs.
#	how to get child?  given?
		self.familyid  = subjectid						#	TODO : this won't be true for mother's

		#	cases (patients): matchingID is the subject's own subjectID
		#	controls: matchingID is subjectID of the associated case (like PatID in this respect).
#	how to get associated case?  given?
		#	mothers: matchingID is subjectID of their own child's associated case. 
		#			That is, a mother's matchingID is the same as their child's. This 
		#			will become clearer when I provide specs for mother subject creation.
#	matchingid is manually set in some tests.  will need to setup for stubbing this.
#		self.matchingid = case case_control_type
#			when 'C' then subjectid
#			else 'asdf'
#		end
	end

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

	#	Pad leading zeroes to familyid
#	no longer used I believe
#	def pad_zeros_to_familyid
#		familyid.try(:gsub!,/\D/,'')
#		self.familyid = sprintf("%06d",familyid.to_i) unless familyid.blank?
#	end 

#	TODO comment out 'til ready to use 'em
#
#	some of these are going to be autogenerated.
#	may have to generate them from within subject though.
#	attr_protected :patid, :childid, :subjectid, :matchingid, :familyid, 
#		:case_control_type, :orderno
#
#	#	Use the ! so that an exception is raised on failure
#	def find_or_generate_next_patid
#		#	cases get a new patid (i think)
#		#	should be able to stub Patid.id to return number so can test
#		if patid.blank?
#			self.patid = Patid.create!.destroy.id
#		end
#	end
#
#	#	Use the ! so that an exception is raised on failure
#	def find_or_generate_next_childid
#		#	cases get a new childid (i think)
#		should be able to stub Childid.id to return number so can test
#		Childid.create!.destroy.id
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
