class ZipCode < ActiveRecordShared

	default_scope :order => :zip_code, :limit => 10
	belongs_to :county

#	validates_presence_of :latitude
#	validates_presence_of :longitude
#	validates_presence_of :county

	validates_presence_of   :zip_code, :city, :state, :zip_class
	validates_uniqueness_of :zip_code
	validates_length_of     :zip_code, :is => 5
	validates_length_of     :city, :state, :zip_class, 
		:maximum => 250, :allow_blank => true


#	acts_like_a_hash(:key => :zip_code)
#	Almost, but length validation would fail.
#	And what would the value field be?


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
