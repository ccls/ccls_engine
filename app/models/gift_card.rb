class GiftCard < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :project

	validates_presence_of   :number
	validates_length_of     :number,     :maximum => 250, :allow_blank => true
	validates_uniqueness_of :number
	validates_length_of     :expiration, :maximum => 250, :allow_blank => true
	validates_length_of     :vendor,     :maximum => 250, :allow_blank => true

	def to_s
		number
	end

	def self.search(params={})
		GiftCardSearch.new(params).gift_cards
	end

end
