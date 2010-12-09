require(File.join(File.dirname(__FILE__), 'config', 'boot'))

# Use the updated rdoc gem rather than version
# included with ruby.
require 'rdoc'
require 'rdoc/rdoc'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Generate documentation for the gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
	rdoc.rdoc_dir = 'rdoc'
	rdoc.title		= 'UCB CCLS Engine'
	rdoc.options << '--line-numbers' << '--inline-source'
	rdoc.rdoc_files.include('README')
	rdoc.rdoc_files.include('lib/**/*.rb')
end

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
		gem.files += FileList['config/document.yml']
		gem.files += FileList['config/photo.yml']
		gem.files += FileList['config/shared_use_db.yml']
#	This may eventually have user/password info, so don't include.
#	It will need to be manually maintained and copied to apps.
#		gem.files += FileList['config/shared_database.yml']
		gem.files += FileList['app/**/*.rb']
		gem.files += FileList['app/**/*.erb']
		gem.files += FileList['lib/**/*.rb']
		gem.files += FileList['lib/**/*.rake']
		gem.files += FileList['generators/**/*']
		gem.files -= FileList['**/versions/*']
#   
#		I'm not quite sure if it matters whether these files
#		are included as 'files' or 'test_files', but
#		they need to be included if I'm gonna use'em.
#
		gem.test_files = FileList['test/**/*.rb']
#	DO NOT INCLUDE test_helper.rb
		gem.test_files -= FileList['test/test_helper.rb']

#
#	It would be really nice if there was a way to
#	add a source here as ryanb-acts-as-list is on
#	http://gems.github.com which is rare now.
#	
#	Something like ...
#
#		gem.add_source('http://gems.github.com')
#
#	or
#
#		gem.add_dependency('ryanb-acts-as-list',
#			:source => 'http://gems.github.com')
#
#	Perhaps I can just jam this in somewhere!
#
#		Gem.sources << 'http://gems.github.com'
#		Gem.configuration.write
#
		gem.add_dependency('rails', '~> 2')
		gem.add_dependency('jrails')
		gem.add_dependency('jakewendt-simply_helpful')
		gem.add_dependency('jakewendt-ruby_extension')
		gem.add_dependency('jakewendt-simply_authorized')
		gem.add_dependency('chronic')
		gem.add_dependency('ssl_requirement')
		gem.add_dependency('ryanb-acts-as-list')
		gem.add_dependency('gravatar')
		gem.add_dependency('paperclip')	#	not all apps use, but should be there
#		gem.add_dependency('thoughtbot-factory_girl')
#		gem.add_dependency('jakewendt-assert_this_and_that')
		gem.add_dependency('jakewendt-calnet_authenticated')
		gem.add_dependency('jakewendt-simply_pages')
		gem.add_dependency('jakewendt-use_db')
		gem.add_dependency('jakewendt-surveyor')
		gem.add_dependency('jakewendt-simply_trackable')
	end
	Jeweler::GemcutterTasks.new
rescue LoadError
	puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

#require 'lib/surveyor/survey_extensions'
