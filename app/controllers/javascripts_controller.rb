class JavascriptsController < ApplicationController

	skip_before_filter :login_required
	ssl_allowed

	#	this controller is made to generate javascripts that
	#	include erb, necessary to include authentication tokens
	#	in dynamically created javascript forms.

end
