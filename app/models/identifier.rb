#	==	requires
#	*	childid (unique)
#	*	subject_id (unique)
#	*	state_id_no ( unique )
class Identifier < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	has_many :interviews

#	validates_presence_of   :study_subject_id
#	validates_presence_of   :subject
#	validates_uniqueness_of :study_subject_id

	#	because subject accepts_nested_attributes for pii 
	#	we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true

	validates_presence_of   :childid
	validates_uniqueness_of :childid

	validates_presence_of   :orderno
	validates_presence_of   :patid
	validates_presence_of   :case_control_type
	validates_uniqueness_of :patid, :scope => [:orderno,:case_control_type]

#	validates_presence_of   :ssn
	validates_uniqueness_of :ssn, :allow_nil => true
#	validates_format_of     :ssn, :with => /\A\d{9}\z/

#	validates_presence_of   :subjectid
	validates_uniqueness_of :subjectid, :allow_nil => true

	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :state_id_no
		o.validates_length_of :case_control_type
		o.validates_length_of :lab_no
		o.validates_length_of :related_childid
		o.validates_length_of :related_case_childid
		o.validates_length_of :ssn
	end

	before_validation :pad_zeros_to_subjectid
	before_validation :pad_zeros_to_matchingid
	before_validation :format_ssn
	before_validation :nullify_subjectid
	before_validation :nullify_ssn

	#	Returns a string containing the patid,
	#	case_control_type and orderno
	def studyid
		"#{patid}-#{case_control_type}-#{orderno}"
	end

protected

	#	Strips out all non-numeric characters
	def format_ssn
		self.ssn.to_s.gsub!(/\D/,'')
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
		self.subjectid = sprintf("%06d",subjectid.to_i) unless subjectid.blank?
	end 

	#	Pad leading zeroes to matchingid
	def pad_zeros_to_matchingid
		matchingid.try(:gsub!,/\D/,'')
		self.matchingid = sprintf("%06d",matchingid.to_i) unless matchingid.blank?
	end 

	#	Pad leading zeroes to familyid
	def pad_zeros_to_familyid
		familyid.try(:gsub!,/\D/,'')
		self.familyid = sprintf("%06d",familyid.to_i) unless familyid.blank?
	end 

	def nullify_subjectid
		#	mysql allows multiple NULLs in unique column
		#	but NOT multiple blanks
		self.subjectid = nil if subjectid.blank?
	end

	def nullify_ssn
		#	mysql allows multiple NULLs in unique column
		#	but NOT multiple blanks
		self.ssn = nil if ssn.blank?
	end

end
