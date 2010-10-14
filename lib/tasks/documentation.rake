#
#	This file has been copied from rails 
#		.../rails-2.3.5/lib/tasks/documentation.rake
#	so that parts of it could be modified.

namespace :doc do	|doc|

#	Rake::RDocTask.new("app") { |rdoc|
#
#		We cannot overwrite or override an RDoc rake task.
#		Redefining it here actually creates another
#		of the same name and both are run when
#		`rake doc:app` is called.	The Rakefile
#		is modified to handle the modifications.
#
#		Actually, that's not entirely true.  This would
#		add another task, but you can remove and override
#		a task.  The rdoc_rails plugin was overriding my
#		override, which caused all the frustration!!!
#
#	}

	plugins = FileList['vendor/plugins/**'].collect { |plugin| 
		File.basename(plugin) }

	namespace :plugins do
		# Define doc tasks for each plugin
		plugins.each do |plugin|

			#	clear rails' Rake::Task of the same name
			Rake::Task[plugin].clear_actions
			Rake::Task[plugin].clear_prerequisites

			Rake::RDocTask.new(plugin) { |rdoc|
				plugin_base  = "vendor/plugins/#{plugin}"
				ENV['format'] ||= 'railsfish'
				rdoc.rdoc_dir = "doc/plugins/#{plugin}"
				rdoc.template = ENV['template'] if ENV['template']
				rdoc.title    = "#{plugin.titlecase} Plugin Documentation"
				rdoc.options << '--line-numbers' << '--inline-source'
				rdoc.options << '--charset' << 'utf-8'
				rdoc.options << '--format'  << ENV['format']
				rdoc.rdoc_files.include("#{plugin_base}/lib/**/*.rb")
				rdoc.rdoc_files.include("#{plugin_base}/app/**/*.rb")

				%w( README README.rdoc ).each do |readme|
					if File.exist?("#{plugin_base}/#{readme}")
						rdoc.main = "#{plugin_base}/#{readme}"
						break
					end
				end
				%w( TODO.org MIT-LICENSE LICENSE CHANGELOG README README.rdoc ).each do |possible_file|
					if File.exist?("#{plugin_base}/#{possible_file}")
						rdoc.rdoc_files.include("#{plugin_base}/#{possible_file}") 
					end
				end
			}

		end
	end

	task :parse_readme => :environment do
		require 'rdoc/markup/to_html'
		h = RDoc::Markup::ToHtml.new
		puts h.convert( File.read('README.rdoc') )
	end

end
