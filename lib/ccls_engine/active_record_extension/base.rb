module Ccls::ActiveRecordExtension::Base

	def self.included(base)
#		base.send(:include, InstanceMethods)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def acts_like_a_hash(*args)
			options = {
				:key   => :key,
				:value => :description
			}.update(args.extract_options!)

			class_eval do

				validates_presence_of   options[:key], options[:value]
				validates_uniqueness_of options[:key], options[:value]
				validates_length_of     options[:key], options[:value],
					:maximum => 250, :allow_blank => true

				# Treats the class a bit like a Hash and
				# searches for a record with a matching key.
				def self.[](key)
					# may need to deal with options[:key] here, but not needed yet
					find_by_key(key.to_s)
				end

			end	#	class_eval do
		end	#	def acts_like_a_hash(*args)


#		#
#		#	Create virtual attribute accessors for datetime parts,
#		#		year, month, day, hour, minute for use by 
#		#		view selectors and model validations?
#		#
#		#	If this all works, may want to separate it out.
#		#
#		def datetime_accessors_for(*args)
#			options = { 
#			}.update(args.extract_options!)
#			args.each do |field|
#
##				What if there is no 'field'?  Typo?
#
##				When to actually compile the 'field'
#
##				define instance variable "#{field}_year"
#
#				define_method "#{field}_year" do
#					#	return the instance variable? or pull it from 'field'?
#				end
#
#				define_method "#{field}_year=" do |new_year|
#					#	just set the instance variable?
#				end
#
#			end
#		end	#	def datetime_accessors_for(*args)

	end	#	module ClassMethods

#	module InstanceMethods
#	end	#	module InstanceMethods

end	#	module Ccls::ActiveRecordExtension::Base
ActiveRecord::Base.send(:include, 
	Ccls::ActiveRecordExtension::Base )
