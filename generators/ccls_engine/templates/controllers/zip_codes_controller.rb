class ZipCodesController < ApplicationController

#	as is no create, update or destroy, token never used anyway
#	skip_before_filter :verify_authenticity_token

	skip_before_filter :login_required

	def index
		@zip_codes = ZipCode.find(:all,
			:select => "city, state, zip_code, county_id, counties.name as county_name",
			:joins => "LEFT JOIN counties ON zip_codes.county_id = counties.id",
			:conditions => [ 'zip_code LIKE ?', "#{params[:q]}%" ])
		respond_to do |format|
			format.html	#	for testing only
			format.json { render :json => @zip_codes }
		end
	end

end
