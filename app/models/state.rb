# Currently just US states + DC
class State < ActiveRecordShared

	acts_as_list

	validates_presence_of   :code
	validates_presence_of   :name
	validates_presence_of   :fips_state_code
	validates_presence_of   :fips_country_code
	validates_uniqueness_of :code
	validates_uniqueness_of :name
	validates_uniqueness_of :fips_state_code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_length_of     :name, :maximum => 250, :allow_blank => true
	validates_length_of     :fips_state_code, :maximum => 250, :allow_blank => true
	validates_length_of     :fips_country_code, :maximum => 250, :allow_blank => true

	# Returns an array of state abbreviations.
	def self.abbreviations
		@@abbreviations ||= all.collect(&:code)
	end

end
