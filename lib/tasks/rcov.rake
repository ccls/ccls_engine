#
#	This is from Advanced Rails Recipes, page 277
#
namespace :test do
	
	desc 'Tracks test coverage with rcov'
	task :coverage do
		rm_f "coverage"
		rm_f "coverage.data"
		
		unless PLATFORM['i386-mswin32']
			rcov = "rcov --sort coverage --rails --aggregate coverage.data " <<
							"--text-summary -Ilib -T " <<
							"-x gems/*,db/migrate/*,jrails/*/*" <<
							',\(eval\),\(recognize_optimized\),\(erb\)' <<    # needed in jruby
							",yaml,yaml/*,lib/tmail/parser.y,jruby.jar!/*" << # needed in jruby
							",html_test/*/*" <<
							",html_test_extension/*/*"
		else
			rcov = "rcov.cmd --sort coverage --rails --aggregate " <<
							"coverage.data --text-summary -Ilib -T"
		end
		
		dirs = Dir.glob("test/**/*_test.rb").collect{|f|File.dirname(f)}.uniq
		lastdir = dirs.pop
		dirs.each do |dir|
			system("#{rcov} --no-html #{dir}/*_test.rb")
		end
		system("#{rcov} --html #{lastdir}/*_test.rb") unless lastdir.nil?
		
		unless PLATFORM['i386-mswin32']
#	jruby-1.5.0.RC1 > PLATFORM 
#	 => "java" 
#			system("open coverage/index.html") if PLATFORM['darwin']
			system("open coverage/index.html")
		else
			system("\"C:/Program Files/Mozilla Firefox/firefox.exe\" " +
						 "coverage/index.html")
		end
	end
end
