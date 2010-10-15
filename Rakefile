require(File.join(File.dirname(__FILE__), 'config', 'boot'))

# Use the updated rdoc gem rather than version
# included with ruby.
#require 'rdoc'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

#desc 'Default: run unit tests.'
#task :default => :test
#
#desc 'Test the ucb_ccls_engine plugin.'
#Rake::TestTask.new(:test) do |t|
#	t.libs << 'lib'
#	t.libs << 'test'
#	t.pattern = 'test/**/*_test.rb'
#	t.verbose = true
#end

desc 'Generate documentation for the ucb_ccls_engine plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
	rdoc.rdoc_dir = 'rdoc'
	rdoc.title		= 'UCB CCLS Engine'
	rdoc.options << '--line-numbers' << '--inline-source'
	rdoc.rdoc_files.include('README')
	rdoc.rdoc_files.include('lib/**/*.rb')
end

#	It would be nice to have the full set of rails rake tasks,
#	but this will probably require some work.
#
#RAILS_ROOT = File.dirname(__FILE__) unless defined?(RAILS_ROOT)
require 'tasks/rails'



begin
	require 'jeweler'
	Jeweler::Tasks.new do |gem|
		gem.name = "jakewendt-ccls_engine"
		gem.summary = %Q{one-line summary of your gem}
		gem.description = %Q{longer description of your gem}
		gem.email = "github@jake.otherinbox.com"
		gem.homepage = "http://github.com/jakewendt/ucb_ccls_engine"
		gem.authors = ["George 'Jake' Wendt"]
		# gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings

		gem.files  = FileList['config/routes.rb']
		gem.files += FileList['app/**/*.rb']
		gem.files += FileList['lib/**/*.rb']
#		gem.files += FileList['generators/**/*']	#	this may need tightened!
		gem.test_files = []
		gem.add_dependency('rails', '~> 2')
		gem.add_dependency('i18n', '=0.3.7')
		gem.add_dependency('jrails')
		gem.add_dependency('jakewendt-rails_helpers')
		gem.add_dependency('jakewendt-ruby_extension')
		gem.add_dependency('chronic')
		gem.add_dependency('ruby-hmac')
		gem.add_dependency('aws-s3')
		gem.add_dependency('ssl_requirement')
		gem.add_dependency('ryanb-acts-as-list')
		gem.add_dependency('gravatar')
		gem.add_dependency('RedCloth')
		gem.add_dependency('paperclip')
		gem.add_dependency('thoughtbot-factory_girl')
		gem.add_dependency('jakewendt-assert_this_and_that')
		gem.add_dependency('jakewendt-calnet_authenticated')
	end
	Jeweler::GemcutterTasks.new
rescue LoadError
	puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
