#	While sweepers are model observers, they only seem
#	to be so within the scope of a given controller.
#	If the 'cache_sweeper' line is not given in the 
#	controller, these observers don't see it.
#	In addition, saving or destroying a page outside
#	of the scope of the controller (ie. from console)
#	will also go unnoticed.
#
#	Interestingly, in unit/model testing, this fails
#	as request is nil.  This means that I don't quite
#	understand how this works.  Perhaps because the cache
#	is in memory and not a file, the server and console
#	are completely separate.  Destroying in the console
#	doesn't effect the server's cache.  That makes sense.
#	So then.  How to get the host_with_port without a 
#	request then?
class PageSweeper < ActionController::Caching::Sweeper
	observe Page

	#	After saving (creating or updating) a page,
	#	expire any associated caches.
	def after_save(page)
		expire_cache(page)
	end

	#	After destroying a page, expire any associated
	#	caches.
	def after_destroy(page)
		expire_cache(page)
	end

	#	Always expire the menu cache.  This may not
	#	be necessary as it only relies on the menu,
	#	path and position attributes which may have
	#	remained unchanged.  Also expire the "show"
	#	action cache.  As the pages are rarely accessed
	#	via /pages/:id, we need to expire the special
	#	routes used by the catch-all route.  In the 
	#	real world, this works just fine, but in testing
	#	the app tries to expire cache when in unit tests
	#	as well as functional tests.  There is no 
	#	"request" in a unit test causing failure and
	#	my usage of ".try"
	def expire_cache(page)
		#	Please note that the "views/" prefix is
		#	internal to rails.  Don't meddle with it.

		#	Expired fragment: views/page_menu (0.0ms)
		expire_fragment 'page_menu'

		#	We don't really access the pages via :id
		#		but they can be so we need to deal with the cache.
		#	Expired fragment: views/dev.sph.berkeley.edu:3000/pages/1 (0.0ms)
		#	Expired fragment: views/dev.sph.berkeley.edu:3000/pages/5 (0.0ms)
		expire_action

		#	Expired fragment: views/dev.sph.berkeley.edu:3000/alpha (0.0ms)
		#	Expired fragment: views/dev.sph.berkeley.edu:3000/ (0.0ms)
		#	This fails for the home page as "/" is 
		#		called "index" by the server
		#	NEEDS to change page.path to /index for home page
		#		be views/dev.sph.berkeley.edu:3000/index !
		page_path = ( page.path == "/" ) ? "/index" : page.path
#		expire_fragment "#{request.host_with_port}#{page_path}"
		expire_fragment "#{request.try(:host_with_port)}#{page_path}"

		#	In production, the page caches weren't expiring
		#	Adding the relative_url_root should fix it.
		page_path = ActionController::Base.relative_url_root.to_s + page_path
		expire_fragment "#{request.try(:host_with_port)}#{page_path}"

	end

end
