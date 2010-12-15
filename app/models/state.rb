# Currently just US states + DC
class State < Shared
	acts_as_list
	validates_presence_of   :code
	validates_presence_of   :name
	validates_presence_of   :fips_state_code
	validates_presence_of   :fips_country_code
	validates_uniqueness_of :code
	validates_uniqueness_of :name
	validates_uniqueness_of :fips_state_code
	with_options :maximum => 250 do |o|
		o.validates_length_of :code
		o.validates_length_of :name
		o.validates_length_of :fips_state_code
		o.validates_length_of :fips_country_code
	end

	# Returns an array of state abbreviations.
	def self.abbreviations
		@@abbreviations ||= all.collect(&:code)
	end

end
