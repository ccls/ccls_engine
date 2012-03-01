class TranslationTable

	def self.[](key=nil)
		short(key) || value(key) || nil
	end

#	DO NOT MEMORIZE HERE.  IT ENDS UP IN ALL SUBCLASSES
#	Doesn't really seem necessary.  It isn't that complicated.

	#	[1,2,999]
	def self.valid_values
#		@@valid_values ||= table.collect{ |x| x[:value] }
		table.collect{ |x| x[:value] }
	end

	#	[['Yes',1],['No',2],["Don't Know",999]]
	def self.selector_options
#		@@selector_options ||= table.collect{|x| [x[:long],x[:value]] }
		table.collect{|x| [x[:long],x[:value]] }
	end

protected

	def self.short(key)
		index = table.find_index{|x| x[:short] == key.to_s }
		( index.nil? ) ? nil : table[index][:value]
	end

	def self.value(key)
		index = table.find_index{|x| x[:value] == key.to_i }
		( index.nil? ) ? nil : table[index][:long] 
	end

	def self.table
		[]
	end
end


class YNDK < TranslationTable
	#	unique translation table
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'yes', :long => "Yes" },
			{ :value => 2,   :short => 'no',  :long => "No" },
			{ :value => 999, :short => 'dk',  :long => "Don't Know" }
		]
	end
end
#
#	YNDK[1]     => 'Yes'
#	YNDK['1']   => 'Yes'
#	YNDK['yes'] => 1
#	YNDK[:yes]  => 1
#	YNDK[:asdf] => nil
#
class YNODK < TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'yes',   :long => "Yes" },
			{ :value => 2,   :short => 'no',    :long => "No" },
			{ :value => 3,   :short => 'other', :long => "Other" },
			{ :value => 999, :short => 'dk',    :long => "Don't Know" }
		]
	end
end
class YNRDK < TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'yes',     :long => "Yes" },
			{ :value => 2,   :short => 'no',      :long => "No" },
			{ :value => 999, :short => 'dk',      :long => "Don't Know" },
			{ :value => 888, :short => 'refused', :long => "Refused" }
		]
	end
end
class ADNA < TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'agree',    :long => "Agree" },
			{ :value => 2,   :short => 'disagree', :long => "Do Not Agree" },
			{ :value => 555, :short => 'na',       :long => "N/A" },
			{ :value => 999, :short => 'dk',       :long => "Don't Know" }
		]
	end
end
