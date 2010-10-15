require 'redcloth'
module RedCloth::Formatters::HTML

	def link_with_prefix(opts)
		if opts[:href] =~ /^\//
			opts[:href] = ActionController::Base.relative_url_root.to_s + opts[:href]
		end
		link_without_prefix(opts)
	end
	alias_method_chain :link, :prefix unless self.instance_methods.include?('link_without_prefix')

	def image_with_prefix(opts)
		if opts[:href] && opts[:href] =~ /^\//
			opts[:href] = ActionController::Base.relative_url_root.to_s + opts[:href]
		end
		if opts[:src] =~ /^\//
			opts[:src] = ActionController::Base.relative_url_root.to_s + opts[:src]
		end
		image_without_prefix(opts)
	end
	alias_method_chain :image, :prefix unless self.instance_methods.include?('image_without_prefix')

end
