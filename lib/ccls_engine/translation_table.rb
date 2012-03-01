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

#	While a HWIA does not differentiate strings and symbols,
#	it does not differentiate between strings and numbers.
#YNORDK = HashWithIndifferentAccess.new({
#	:yes   => 1,
##	:true  => 1,
#	:no    => 2,
##	:false => 2,
#	:other => 3,
#	:dk    => 999,
##	:refused => 0,
#	:refused => 888,
##	'0'    => 'Refused',
#	'888'  => 'Refused',
#	'1'    => 'Yes',
#	'2'    => 'No',
#	'3'    => 'Other',
#	'999'  => "Don't Know",
##	0      => 'Refused',
#	888    => 'Refused',
#	1      => 'Yes',
#	2      => 'No',
#	3      => 'Other',
#	999    => "Don't Know"
#}).freeze	
#	YNORDK includes all, but isn't actually used.
#	Just the following are. Perhaps should define each separately?
#YNDK  = YNORDK;
#YNODK = YNORDK;
#YNRDK = YNORDK;


#ADNA = HashWithIndifferentAccess.new({
#	:agree => 1,
#	:disagree => 2,
##	:na    => 888,
#	:na    => 555,
#	:dk    => 999,
#	'1'    => 'Agree',
#	'2'    => 'Do Not Agree',
##	'888'  => 'N/A',
#	'555'  => 'N/A',
#	'999'  => "Don't Know",
#	1      => 'Agree',
#	2      => 'Do Not Agree',
##	888    => 'N/A',
#	555    => 'N/A',
#	999    => "Don't Know"
#}).freeze
#
#def yndk_selector_options
##	[['Yes',1],['No',2],["Don't Know",999]]
#	YNDK.selector_options
#end
#def ynodk_selector_options
##	[['Yes',1],['No',2],['Other',3],["Don't Know",999]]
#	YNODK.selector_options
#end
#def ynrdk_selector_options
##	[['Yes',1],['No',2],["Don't Know",999],['Refused',888]]
#	YNRDK.selector_options
#end
#def adna_selector_options
#	ADNA.selector_options
##	[['Agree',1],['Do Not Agree',2],['N/A',555],["Don't Know",999]]
#end

#	methods or constants?
#def valid_yndk_values
#	[1,2,999]
#end
#def valid_ynodk_values
#	[1,2,3,999]
#end
#def valid_ynrdk_values
#	[1,2,888,999]
#end
#def valid_adna_values
#	[1,2,555,999]
#end
