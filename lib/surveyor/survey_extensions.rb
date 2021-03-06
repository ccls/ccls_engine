#if surveyor_gem = Gem.searcher.find('surveyor')
#	
#	http://github.com/breakpointer/surveyor/issues/issue/45
#
#	Survey access_code not guaranteed to be unique
#
#	As there is no model validation or unique index in the 
#	database, there is no guarantee that your survey access_code 
#	will be unique.  It is just a normalized version of your 
#	survey title.  
#
#Running ...
#<pre>
# rake surveyor FILE=surveys/kitchen_sink_survey.rb APPEND=true
# rake surveyor FILE=surveys/kitchen_sink_survey.rb APPEND=true
# script/console
# Survey.all.collect(&:access_code)
#</pre>
#should show this to be true.
#
#This will show both surveys as able to be taken, but will 
#	only allow the first one when the attempt is made as the 
#	survey is found by
#
#<pre>
#@survey = Survey.find_by_access_code(params[:survey_code])
#</pre>
#
#In addition, adding a unique index to the db and model will 
#	make a mess when running 
#<pre>
#rake surveyor FILE=surveys/kitchen_sink_survey.rb APPEND=true
#rake surveyor FILE=surveys/kitchen_sink_survey.rb APPEND=true
#</pre>
#as the access_code is not unique and the survey fixtures are 
#	loaded last, leaving the associations with an invalid survey_id.  
#	To avoid this, the survey fixture should probably be attempted first.
#
#
#Update...
#
#Adding something like ...
#<pre>
#def access_code=(value)
#  counter = 2
#  original_value = value
#  while( ( survey = Survey.find_by_access_code(value) ) && 
#    ( self.id != survey.id ) )
#    value = [original_value,"_",counter].join
#    counter += 1
#  end
#  super
#end
#</pre>
#... to Survey seems to provide a "fix" for this "problem", 
#	although I don't know how kosher it is.
#
#It works in my test environment, but does not actually work 
#	in the "rake surveyor" task as the survey is built from a 
#	different Survey model completely and then loaded into the 
#	database and not created though the application.
#
#My final "fix" was to add 
#<pre>
#require 'lib/surveyor/survey_extensions'
#</pre>
#to my Rakefile and create the file
#<pre>
## > cat lib/surveyor/survey_extensions.rb
#if surveyor_gem = Gem.searcher.find('surveyor')
#  require surveyor_gem.full_gem_path + '/script/surveyor/parser'
#  require surveyor_gem.full_gem_path + '/script/surveyor/survey'
#end
#
#module SurveyParser
#module SurveyExtensions
#  def self.included(base)
#    base.class_eval do
#      def initialize_with_unique_access_code(obj, args, opts)
#        initialize_without_unique_access_code(obj, args, opts)
#        counter = 2
#        ac = self.access_code
#        original_ac = self.access_code
#        while( survey = ::Survey.find_by_access_code(ac) ) 
#          ac = [original_ac,"_",counter].join
#          counter += 1
#        end
#        self.access_code = ac
#      end
#      alias_method_chain :initialize, :unique_access_code
#    end
#  end
#end
#end
#SurveyParser::Survey.send(:include, SurveyParser::SurveyExtensions)
#</pre>
#It is not as clean as I would've liked, but works.
#
module SurveyParser
module SurveyExtensions
	def self.included(base)
		base.class_eval do
			def initialize_with_unique_access_code(obj, args, opts)
				initialize_without_unique_access_code(obj, args, opts)
				counter = 2
				ac = self.access_code
				original_ac = self.access_code
				while( survey = ::Survey.find_by_access_code(ac) ) 
					ac = [original_ac,"_",counter].join
					counter += 1
				end
				self.access_code = ac
			end
			alias_method_chain :initialize, :unique_access_code
		end
	end
end
end
#	need in rvm/jruby
#require 'vendor/plugins/surveyor/script/surveyor/parser'
if surveyor_gem = Gem.source_index.find_name('ccls-surveyor').last
	require surveyor_gem.full_gem_path + '/script/surveyor/parser'
	require surveyor_gem.full_gem_path + '/script/surveyor/survey'
SurveyParser::Survey.send(:include, SurveyParser::SurveyExtensions)
end
