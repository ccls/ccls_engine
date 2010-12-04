#	==	requires
#	*	operational_event_type_id
class OperationalEvent < Shared
	default_scope :order => 'occurred_on DESC'
	belongs_to :enrollment

	belongs_to :operational_event_type
	validates_presence_of :operational_event_type_id
	validates_presence_of :operational_event_type

	validates_complete_date_for :occurred_on, 
		:allow_nil => true

	validates_length_of :description,
		:maximum => 250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

	#	find wrapper
	def self.search(options={})
		find(:all,
			:joins => joins(options),
			:order => order(options))
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
		if options.has_key?(:order) && valid_order?(options[:order])
			case options[:order]
				when 'type' then :operational_event_type
				else nil
			end
		else
			nil
		end	
	end

end
