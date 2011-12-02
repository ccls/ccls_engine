require(File.join(File.dirname(__FILE__), 'config', 'boot'))

# Use the updated rdoc gem rather than version
# included with ruby.
require 'rdoc'
require 'rdoc/rdoc'

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc 'Generate documentation for the gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
	rdoc.rdoc_dir = 'rdoc'
	rdoc.title		= 'UCB CCLS Engine'
	rdoc.options << '--line-numbers' #<< '--inline-source'
	rdoc.rdoc_files.include('README')
	rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'tasks/rails'

begin
	require 'jeweler'
	Jeweler::Tasks.new do |gem|
		gem.name = "ccls-ccls_engine"
		gem.summary = %Q{one-line summary of your gem}
		gem.description = %Q{longer description of your gem}
		gem.email = "github@jakewendt.com"
		gem.homepage = "http://github.com/ccls/ccls_engine"
		gem.authors = ["George 'Jake' Wendt"]
		# gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings

		gem.files  = FileList['config/home_exposure_response_fields.yml']
		gem.files += FileList['config/abstract_fields.yml']
		gem.files += FileList['config/abstract_sections.yml']
		gem.files += FileList['config/shared_use_db.yml']
#	This may eventually have user/password info, so don't include.
#	It will need to be manually maintained and copied to apps.
#		gem.files += FileList['config/shared_database.yml']
		gem.files += FileList['rails/init.rb']
		gem.files += FileList['app/models/*.rb']
		gem.files -= FileList['app/models/user.rb']
		gem.files += FileList['lib/**/*.rb']
		gem.files += FileList['lib/**/*.rake']
		gem.files += FileList['generators/**/*']
		gem.files -= FileList['**/versions/*']
		gem.files -= FileList['lib/ccls_engine/warble.rb']

		gem.test_files = FileList['test/unit/ccls/*.rb']

		gem.add_dependency('rails', '~> 2')
#	had to explicitly add rails components as greater
#	versions were being loaded 
		gem.add_dependency('activerecord', '~> 2')
		gem.add_dependency('activeresource', '~> 2')
		gem.add_dependency('activesupport', '~> 2')
		gem.add_dependency('actionpack', '~> 2')
		gem.add_dependency('jrails')	# hopefully, can drop soon, don't know if I use it
		gem.add_dependency('ccls-calnet_authenticated','>= 1.2.0')
		gem.add_dependency('ccls-simply_authorized')

#
#	Chronic has gotten quite finicky so trying to avoid.
#	Let's see if I can.  Doubt it.
#	A couple places still used in ...
#		./lib/ccls_engine/factory_test_helper.rb
#	but I've managed to eradicate it elsewhere.
		gem.add_dependency('chronic')
#

		gem.add_dependency('ssl_requirement')
		gem.add_dependency('ryanb-acts-as-list')
		gem.add_dependency('thoughtbot-factory_girl')
		gem.add_dependency('ucb_ldap', '>= 1.4.2')
		gem.add_dependency('rubycas-client', '>= 2.2.1')
		gem.add_dependency('ccls-use_db')
		gem.add_dependency('ccls-common_lib')
	end
	Jeweler::GemcutterTasks.new
rescue LoadError
	puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

#	This is an array of Regexs excluded from test coverage report.
RCOV_EXCLUDES = ['lib/ccls_engine.rb','lib/ccls_engine/shared_database.rb',
	'app/models/search.rb','lib/ccls_engine/factories.rb',
	'lib/ccls_engine/controller.rb']

