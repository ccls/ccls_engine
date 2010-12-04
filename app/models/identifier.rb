#	==	requires
#	*	childid (unique)
#	*	subject_id (unique)
class Identifier < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	has_many :interviews

	validates_presence_of   :study_subject_id
	validates_presence_of   :subject
	validates_uniqueness_of :study_subject_id

	validates_presence_of   :childid
	validates_uniqueness_of :childid

	validates_presence_of   :orderno
	validates_presence_of   :patid
	validates_presence_of   :case_control_type
	validates_uniqueness_of :patid, :scope => [:orderno,:case_control_type]

	validates_presence_of   :ssn
	validates_uniqueness_of :ssn
	validates_format_of     :ssn, :with => /\A\d{9}\z/

	validates_presence_of   :subjectid
	validates_uniqueness_of :subjectid

	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :case_control_type
		o.validates_length_of :lab_no
		o.validates_length_of :related_childid
		o.validates_length_of :related_case_childid
		o.validates_length_of :ssn
	end

	before_validation :pad_zeros_to_subjectid
	before_validation :format_ssn

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

end
