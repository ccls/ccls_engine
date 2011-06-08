class ZipCodesController < ApplicationController

#	as is no create, update or destroy, token never used anyway
#	skip_before_filter :verify_authenticity_token

	skip_before_filter :login_required

	def index
		@zip_codes = ZipCode.find(:all,
			:limit => 10 )
#	may want to require AT LEAST 1 digit.  There are over 40000 zip codes in the db.
#		@zip_codes = ZipCode.find(:all,:conditions => [
#			'zip_code LIKE ?', "#{params[:q]}%" ])
#			'zip_code LIKE ?', params[:q] << "%" ])
	end

end
