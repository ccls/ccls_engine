#		RAILS_GEM_VERSION to use the latest version installed.
gem 'activesupport', '~>2.3'

#	for alias_method_chain
require 'active_support'	#	note the name disparity
#require 'active_support/core_ext'	#	note the name disparity

module WarblerWar

	def self.included(base)
		base.class_eval do
			alias_method_chain :apply, :removal
		end
	end

	def apply_with_removal(config,&block)
		apply_without_removal(config,&block)
		puts "BEFORE:#{@files.keys.length}"
		@files.delete_if {|k,v|
			#	MUST REMOVE SPECIFICATION TOO!
			#	Wasn't removing 3.0 specs and then rails
			#	complained that rails 2.3.10 wasn't installed??
			k =~ %r{WEB-INF/gems/[^/]+/(#{config.remove_gem_files.join('|')})}
		} unless config.remove_gem_files.empty?
		puts "AFTER:#{@files.keys.length} (should be ~1000 less)"
	end

end
Warbler::War.send(:include,WarblerWar)

module WarblerConfig

	def self.included(base)
		base.class_eval do
			attr_accessor :remove_gem_files
			alias_method_chain :initialize, :removal
		end
	end

	#	ALWAYS RECEIVE AND PASS A BLOCK!
	def initialize_with_removal(warbler_home = Warbler::WARBLER_HOME,&block)
#		@remove_gem_files = []
# just before creating the war file, files matching
# these will be removed from the list. 
#   WEB-INF/gems/gems/REGEX
		@remove_gem_files = %w( 
			activesupport-3
			activerecord-3
			activeresource-3
			actionpack-3
			actionmailer-3
			activemodel-3
			railties-3
			rails-3
			rack-1.2.1
			rack-mount-
			rack-test-
			abstract-
			arel-
			bundler-
			erubis-
			mail-
			polyglot-
			thor-
			treetop-
			tzinfo-
			RedCloth-4.2.6
		)
		initialize_without_removal(warbler_home,&block)
	end

end
Warbler::Config.send(:include,WarblerConfig)

