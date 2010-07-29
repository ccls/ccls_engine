module RedCloth::Formatters::HTML

	def link_with_prefix(opts)
		if opts[:href] =~ /^\//
			opts[:href] = ActionController::Base.relative_url_root + opts[:href]
		end
		link_without_prefix(opts)
	end
	alias_method_chain :link, :prefix

	def image_with_prefix(opts)
		if opts[:href] && opts[:href] =~ /^\//
			opts[:href] = ActionController::Base.relative_url_root + opts[:href]
		end
		if opts[:src] =~ /^\//
			opts[:src] = ActionController::Base.relative_url_root + opts[:src]
		end
		image_without_prefix(opts)
	end
	alias_method_chain :image, :prefix

end
