class GiftCard < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :project
	validates_presence_of   :number
	validates_uniqueness_of :number
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :expiration
		o.validates_length_of :vendor
		o.validates_length_of :number
	end

	def to_s
		number
	end

	def self.search(params={})
		GiftCardSearch.new(params).gift_cards
	end

end
