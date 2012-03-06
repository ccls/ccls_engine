#
#	Originally from http://railscasts.com/episodes/111-advanced-search-form
#	however, I have modified it heavily and made it quite abstract.
#	Its still a bit muddy, but I'd like to replace it with rsolr.
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
		self.class.send('attr_accessor', *searchable_attributes)
		options.each do |attr,value|
			if attr_accessors.include?(attr.to_sym) ||
				searchable_attributes.include?(attr.to_sym)
				self.send("#{attr}=",value)
			end
		end
	end

	def self.inherited(subclass)
		#	USE DUP! Without it, the two will share the same object_id
		#	resulting is cross contamination
		subclass.searchable_attributes = searchable_attributes.dup
		subclass.attr_accessors = attr_accessors.dup
		subclass.valid_orders = valid_orders.dup
		#	Create 'shortcut'
		#	StudySubjectSearch(options) -> StudySubjectSearch.new(options)
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

	def select
		#	:select - By default, this is "*" as in "SELECT * FROM", 
		#		but can be changed if you, for example, want to do a join 
		#		but not include the joined columns. Takes a string with the 
		#		SELECT SQL fragment (e.g. "id, name").
		selects = private_methods(false).grep(/_selects$/).sort.map { |m| send(m) }.compact
		#	select CANNOT be ''
		#	ActiveRecord::StatementInvalid: Mysql::Error: You have an error in your SQL syntax; 
		#		check the manual that corresponds to your MySQL server version for the right 
		#		syntax to use near 'FROM `study_subjects`   LIMIT 0, 25' at line 1: 
		#		SELECT  FROM `study_subjects`   LIMIT 0, 25
		#	nil will cause default use of '*', which could also be passed
		( selects.empty? ) ? nil : selects.join(',')
	end

	def group
		#	:group - An attribute name by which the result should be grouped. 
		#		Uses the GROUP BY SQL-clause
		groups = private_methods(false).grep(/_groups$/).sort.map { |m| send(m) }.compact
		#	ActiveRecord::StatementInvalid: Mysql::Error: You have an error in your SQL syntax; 
		#		check the manual that corresponds to your MySQL server version for the right 
		#		syntax to use near '' at line 1: SELECT * FROM `study_subjects`  GROUP BY
		#	nil will cause group by to not be used
		( groups.empty? ) ? nil : groups.join(',')
	end

	def having
		#	:having - Combined with :group this can be used to filter the records 
		#		that a GROUP BY returns. Uses the HAVING SQL-clause.
		#	this is very similar to :conditions/WHERE so may have to add all of the
		#	conditions_* methods to handle
		[having_clauses.join(' AND '), *having_options]
	end

	def having_clauses
		having_parts.map { |condition| condition.first }
	end

	def having_options
		parts = having_parts.map { |condition| condition[1..-1] }.flatten(1)
#	just like conditions, these parts need to be hashes of symbol names
#	for use in the sql command.  Not ?.
		[parts.inject(:merge)]
	end

	def having_parts
		private_methods(false).grep(/_havings$/).map { |m| send(m) }.compact
	end

end
