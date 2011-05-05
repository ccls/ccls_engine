class ZipCode < Shared
	belongs_to :county

	validates_uniqueness_of :zip_code

	validates_presence_of :zip_code
#	validates_presence_of :latitude
#	validates_presence_of :longitude
	validates_presence_of :city
	validates_presence_of :state
#	validates_presence_of :county
	validates_presence_of :zip_class

	validates_length_of :zip_code, :is => 5

	with_options :maximum => 250 do |o|
		o.validates_length_of :city
		o.validates_length_of :state
#		o.validates_length_of :county
		o.validates_length_of :zip_class
	end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](zip_code)
		find_by_zip_code(zip_code.to_s) #|| raise(NotFound)
	end

end
