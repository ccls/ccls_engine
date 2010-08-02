class StylesheetsController < ApplicationController

	skip_before_filter :login_required

	def ssl_allowed?
		true	#	for any and all dynamic stylesheets
	end

	#	this controller is made to generate stylesheets that
	#	include erb, necessary to deal with different path lengths
	#	and the like due to differing path lengths in the
	#	production environment.

end
