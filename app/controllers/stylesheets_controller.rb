class StylesheetsController < ApplicationController

	skip_before_filter :login_required
	ssl_allowed

	#	this controller is made to generate stylesheets that
	#	include erb, necessary to deal with different path lengths
	#	and the like due to differing path lengths in the
	#	production environment.

end
