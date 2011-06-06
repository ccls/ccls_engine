module Ccls;end

#module CclsEngine;end
namespace :test do
	namespace :units do
		Rake::TestTask.new(:ccls_engine => "db:test:prepare") do |t|
			t.pattern = File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/unit/ccls/*_test.rb'))
			t.libs << "test"
			t.verbose = true
		end
	end
	namespace :functionals do
		Rake::TestTask.new(:ccls_engine => "db:test:prepare") do |t|
			t.pattern = File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/functional/ccls/*_test.rb'))
			t.libs << "test"
			t.verbose = true
		end
	end
end
Rake::Task['test:functionals'].prerequisites.unshift(
	"test:functionals:ccls_engine" )
Rake::Task['test:units'].prerequisites.unshift(
	"test:units:ccls_engine" )

#	I thought of possibly just including this file
#	but that would make __FILE__ different.
#	Hmmm

#
#	used in simply_helpful's rake test:coverage to run gem's 
#		tests in the context of the application
#
@gem_test_dirs ||= []
#@gem_test_dirs << File.expand_path(File.join(File.dirname(__FILE__),
#	'/../../test/unit/ccls/'))
#@gem_test_dirs << File.expand_path(File.join(File.dirname(__FILE__),
#	'/../../test/unit/ccls/helpers/'))
#@gem_test_dirs << File.expand_path(File.join(File.dirname(__FILE__),
#	'/../../test/functional/ccls/'))

#
# More flexible.  Find all test files, pick out their dir, uniq 'em and add.
#
Dir.glob( 
	File.expand_path(File.join(File.dirname(__FILE__),
		'/../../test/*/ccls/**/*_test.rb'))
).collect{|f|
	File.dirname(f)
}.uniq.each{ |dir|
	@gem_test_dirs << dir
}
