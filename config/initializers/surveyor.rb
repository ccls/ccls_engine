Surveyor::Config.run do |config|
  config['default.relative_url_root'] = nil # "surveys/" # should end with '/'
  config['default.title'] = nil # "You can take these surveys:"
  config['default.layout'] = 'survey' # "surveyor_default"
  config['default.index'] =  nil # "/surveys" # or :index_path_method
  config['default.finish'] = :survey_finished_path
#	must use a symbol!
#'/survey_finished' # "/surveys" # or :finish_path_method
  config['use_restful_authentication'] = false # set to true to use restful authentication
  config['extend'] = %w(survey surveyor_controller response response_set)
end

# require 'models/survey_extensions' # Extended the survey model
# require 'helpers/surveyor_helper_extensions' # Extend the surveyor helper

#require 'models/survey_extensions'
#require 'models/response_set_extensions'
#require 'models/response_extensions'
