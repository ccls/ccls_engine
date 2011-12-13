#	==	requires
#	*	operational_event_type_id
class OperationalEvent < ActiveRecordShared

	default_scope :order => 'occurred_on DESC'
	belongs_to :enrollment
	belongs_to :operational_event_type


#
#	No validation for presence of enrollment ????
#	TODO I think that this may be an oversight.
#
	validates_presence_of :enrollment_id
	validates_presence_of :enrollment, :if => :enrollment_id


	validates_presence_of :operational_event_type_id
	validates_presence_of :operational_event_type, :if => :operational_event_type_id

	validates_complete_date_for :occurred_on, :allow_nil => true
	validates_length_of :description, :maximum => 250, :allow_blank => true
	validates_length_of :event_notes, :maximum => 250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

	#	find wrapper
	def self.search(options={})
		find(:all,
			:joins => joins(options),
			:order => order(options),
			:conditions => conditions(options)
		)
	end

	before_save :copy_operational_event_type_description

#	TODO make protected?

	def copy_operational_event_type_description
		if self.description.blank?
			self.description = operational_event_type.description
		end
	end

protected

	def self.valid_orders
		%w( id occurred_on description type )
	end

	def self.valid_order?(order)
		valid_orders.include?(order)
	end

	def self.order(options={})
		if options.has_key?(:order) && valid_order?(options[:order])
			order_string = case options[:order]
				when 'type' then 'operational_event_types.description'
				else options[:order]
			end
			dir = case options[:dir].try(:downcase)
				when 'asc'  then 'asc'
				when 'desc' then 'desc'
				else 'desc'
			end
			[order_string,dir].join(' ')
		else
			nil
		end
	end

	def self.joins(options={})
#	TODO may have to use sql for LEFT JOINS rather than the rails symbol
		joins = []
		if options.has_key?(:order) && valid_order?(options[:order])
			case options[:order]
				when 'type' then joins << :operational_event_type
#	'LEFT JOIN operational_event_types ON operational_events.operational_event_type_id = operational_event_types.id',
			end
		end	
		if options.has_key?(:study_subject_id) and !options[:study_subject_id].blank?
			joins << :enrollment
#	'LEFT JOIN enrollments ON operational_events.enrollment_id = enrollments.id',
		end
		joins
	end

	def self.conditions(options={})
		conditions = [[],[]]
		if options.has_key?(:study_subject_id) and !options[:study_subject_id].blank?
			conditions[0] << '(enrollments.study_subject_id = ?)'
			conditions[1] << options[:study_subject_id]
		end
		unless conditions.flatten.empty?
			[ conditions[0].join(' AND '), *(conditions[1].flatten) ]
		else
			nil
		end
	end

end
