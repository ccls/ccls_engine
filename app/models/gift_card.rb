class GiftCard < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
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
