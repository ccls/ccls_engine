#
#	From http://railscasts.com/episodes/111-advanced-search-form
#
class Search

	class << self
		def valid_orders
			@valid_orders
		end
		def valid_orders=(more_orders)
			@valid_orders = more_orders
		end
		def searchable_attributes
			@searchable_attributes
		end
		def searchable_attributes=(more_attributes)
			@searchable_attributes = more_attributes
		end
		def attr_accessors
			@attr_accessors
		end
		def attr_accessors=(more_accessors)	#	extend with += [ :something ] NOT << :something
			@attr_accessors = more_accessors
			attr_accessor *@attr_accessors
		end
	end
	self.valid_orders = HashWithIndifferentAccess.new
	self.searchable_attributes = []
	self.attr_accessors = [ :order, :dir, :includes, :paginate, :per_page, :page ]

	def valid_orders
		self.class.valid_orders
	end

	def searchable_attributes
		self.class.searchable_attributes
	end

	def attr_accessors
		self.class.attr_accessors
	end

	def search_order
		if valid_orders.has_key?(@order)
			order_string = if valid_orders[@order].blank?
				@order
			else
				valid_orders[@order]
			end
			dir = case @dir.try(:downcase)
				when 'desc' then 'desc'
				else 'asc'
			end
			[order_string,dir].join(' ')
		else
			nil
		end
	end

private

	def paginate?
		(@paginate.nil?) ? true : @paginate
	end

	def initialize(options={})
#		self.class.send('attr_accessor', *searchable_attributes)
		self.class.send('attr_accessor', *searchable_attributes)
		options.each do |attr,value|
			if attr_accessors.include?(attr.to_sym) ||
				searchable_attributes.include?(attr.to_sym)
				self.send("#{attr}=",value)
			end
		end
	end

	def self.inherited(subclass)
		subclass.searchable_attributes = searchable_attributes
		subclass.attr_accessors = attr_accessors
		subclass.valid_orders = valid_orders
		#	Create 'shortcut'
		#	SubjectSearch(options) -> SubjectSearch.new(options)
		Object.class_eval do
			define_method subclass.to_s do |*args|
				subclass.send(:new,*args)
			end
		end
	end

	#	This may work for the simple stuff, but I suspect
	#	that once things get complicated, it will unravel.

	def conditions
		[conditions_clauses.join(' AND '), *conditions_options]
	end

	def conditions_clauses
		conditions_parts.map { |condition| condition.first }
	end

	def conditions_options
		#	conditions_parts.map { |condition| condition[1..-1] }.flatten
		#
		#	the above flatten breaks the "IN (?)" style search
		#
		#	conditions_parts.map { |condition| condition[1..-1] }
		#	This fixes it, but is kinda bulky
#		opts = []
#		conditions_parts.each do |condition|
#			condition[1..-1].each{|cp| opts << cp}
#		end
#		opts 
		#	That's better!
		parts = conditions_parts.map { |condition| condition[1..-1] }.flatten(1)

#	The "parts" contain the variables inserted in the query.
#	Apparently, we can't mix the ? style with the :var_name style, 
#	but we can only have 1 trailing hash so we need to merge all
#	of the trailing hashes.

#		symbol_options = HashWithIndifferentAccess.new
#		while( !( h = parts.extract_options! ).empty? ) do
#			symbol_options.merge!(h)
#		end

#		parts.push(symbol_options)

#		caller is expecting an array
		[parts.inject(:merge)]
	end

	def conditions_parts
		private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
	end

	#	Join order can be important if joining on other joins
	#	so added a sort.  Added a "a_" to those joins which must go first.
	#	Crude solution, but a solution nonetheless.
	def joins
		private_methods(false).grep(/_joins$/).sort.map { |m| send(m) }.compact
	end

end
