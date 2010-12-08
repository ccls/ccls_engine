module ActiveRecordExtension
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def random
			count = count()
			if count > 0
				first(:offset => rand(count))
			else
				nil
			end
		end

		def validates_absence_of(*attr_names)
			configuration = { :on => :save }
			configuration.update(attr_names.extract_options!)

			send(validation_method(configuration[:on]), configuration) do |record|
				attr_names.each do |attr_name|
					unless record.send(attr_name).blank?
						record.errors.add(attr_name, configuration[:message])
					end
				end
			end
		end

		#	This doesn't work as one would expect if the column
		#	is a DateTime instead of just a Date.
		#	For some reason, *_before_type_cast actually
		#	returns a parsed DateTime?
		def validates_complete_date_for(*attr_names)
			configuration = { :on => :save,
				:message => "is not a complete date." }
			configuration.update(attr_names.extract_options!)

			send(validation_method(configuration[:on]), configuration) do |record|
				attr_names.each do |attr_name|

					value = record.send("#{attr_name}_before_type_cast")
					unless( configuration[:allow_nil] && value.blank? ) ||
						( !value.is_a?(String) )
						date_hash = Date._parse(value)
						unless date_hash.has_key?(:year) &&
							date_hash.has_key?(:mon) &&
							date_hash.has_key?(:mday)
							record.errors.add(attr_name, configuration[:message])
						end
					end
				end
			end
		end

	end

end
ActiveRecord::Base.send(:include,ActiveRecordExtension)
