class Autotest::Rails

#
#	Need both the mapping and the extra files
#
	def run_with_ccls_engine
		add_exception %r%config/%
		add_exception %r%versions/%
		add_exception %r%\.git/%
		self.extra_files << File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/unit/ccls/'))

		self.extra_files << File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/functional/ccls/'))

		add_mapping( 
			%r{^#{File.expand_path(File.join(File.dirname(__FILE__),'/../../test/'))}/(unit|functional)/ccls/.*_test\.rb$}
			) do |filename, _|
			filename
		end
		run_without_ccls_engine
	end
	alias_method_chain :run, :ccls_engine


end
