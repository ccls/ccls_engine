class ZipCode < ActiveRecordShared

	default_scope :order => :zip_code, :limit => 10
	belongs_to :county

#	validates_presence_of :latitude
#	validates_presence_of :longitude
#	validates_presence_of :county

	validates_presence_of   :zip_code
	validates_uniqueness_of :zip_code
	validates_length_of     :zip_code, :is => 5
	validates_presence_of   :city
	validates_length_of     :city, :maximum => 250, :allow_blank => true
	validates_presence_of   :state
	validates_length_of     :state, :maximum => 250, :allow_blank => true
	validates_presence_of   :zip_class
	validates_length_of     :zip_class, :maximum => 250, :allow_blank => true

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](zip_code)
		find_by_zip_code(zip_code.to_s) #|| raise(NotFound)
	end

	def to_s
		"#{city}, #{state} #{zip_code}"
	end

#	def zip
#		zip_code
#	end

end
