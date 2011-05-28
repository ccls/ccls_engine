# don't know exactly
class Person < Shared
	acts_as_list
	default_scope :order => :position

#	belongs_to :context
	has_many :interviews, :foreign_key => 'interviewer_id'

	has_many :organizations

	validates_presence_of :last_name
#	TODO couldn't this just be a one liner?
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :first_name
		o.validates_length_of :last_name
		o.validates_length_of :honorific
	end

	named_scope :interviewers, :conditions => { :person_type_id => 3 }

	#	Returns string containing first and last name
	def full_name
		"#{first_name} #{last_name}"
	end

	#	Returns full_name
	def to_s
		full_name
	end

end
