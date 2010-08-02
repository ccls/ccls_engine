class JavascriptsController < ApplicationController

	skip_before_filter :login_required

	def ssl_allowed?
		true	#	for any and all dynamic javascripts
	end

	#	this controller is made to generate javascripts that
	#	include erb, necessary to include authentication tokens
	#	in dynamically created javascript forms.

end
