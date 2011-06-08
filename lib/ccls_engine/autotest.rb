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

		##
		#	This stops the ...
		#
		#	Unable to map class Ccls::IdentifierTest to a file
		#	Unable to map class Ccls::SubjectTest to a file
		#
		#	By default autotest is expecting all the namespaces to end with Test
		#		ie. CclsTest::IdentifierTest
		#	Could have renamed the dir, I suppose.
		#
		Dir[File.join(File.dirname(__FILE__),'/../../test/unit/**/*rb')].each do |f|
#	the condition isn't as important as grabbing "ccls/test_file_name.rb" for camelcasing
			if f =~ /test\/unit\/(ccls\/.*)\.rb/
				self.extra_class_map[$1.camelcase] = File.expand_path(f)
			end
		end
		Dir[File.join(File.dirname(__FILE__),'/../../test/functional/**/*rb')].each do |f|
			if f =~ /test\/functional\/(ccls\/.*)\.rb/
				self.extra_class_map[$1.camelcase] = File.expand_path(f)
			end
		end

		run_without_ccls_engine
	end
	alias_method_chain :run, :ccls_engine


end
