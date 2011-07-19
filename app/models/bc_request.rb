class BcRequest < Shared

	def self.statuses
		%w( active waitlist pending complete )
	end

end
