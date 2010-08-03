class Document < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'
#	has_and_belongs_to_many :users
#	has_and_belongs_to_many :groups

	validates_presence_of :title
	validates_length_of :title, :minimum => 4

	validates_uniqueness_of :document_file_name, :allow_nil => true

	before_validation :nullify_blank_document_file_name

#>> Rails.root.to_s.split('/')
#=> ["", "var", "lib", "tomcat5", "webapps", "clic", "WEB-INF"]

#>> Rails.root.to_s.split('/')
#=> ["", "Users", "jakewendt", "github_repo", "jakewendt", "ucb_ccls_clic"]

#		path = if Rails.env == 'production'
#	#		app_name = ( Rails.respond_to?(:app_name) && Rails.app_name ) || 
#	#			$rails_app_name ||
#			app_name = ( defined?(RAILS_APP_NAME) && RAILS_APP_NAME ) ||
#				Rails.root.to_s.split('/').reject{|x|x ==  "WEB-INF"}.last
#			"/home/tomcat/" << app_name << "/:attachment/:id/:filename"
#	#	":rails_root/#{Rails.env}/:attachment/:id/:filename"
#		else
#			":rails_root/#{Rails.env}/:attachment/:id/:filename"
#	#		':rails_root/public/system/:attachment/:id/:style/:filename'
#		end

#	url = if Rails.env == 'production'
##		'http://ccls.berkeley.edu/ucb_sph_ccls.uploads/:attachment/:id/:style/:filename'
#		'/../ucb_sph_ccls.uploads/system/:attachment/:id/:style/:filename'
#	else
#		'/system/:attachment/:id/:style/:filename'
#	end

#	#	documents/2/list_wireframe.pdf 
#	path = if Rails.env == 'test'
#		':rails_root/test/:attachment/:id/:filename'
#	else
#		':rails_root/:attachment/:id/:filename'
#	end
#	path = ":rails_root/#{Rails.env}/:attachment/:id/:filename"
#	url  = ':rails_root/:attachment/:id/:filename'

#	has_attached_file :document, :path => path
	has_attached_file :document,
		YAML::load(ERB.new(IO.read(File.expand_path(
#			File.join(Rails.root,'config/photo.yml')
			File.join(File.dirname(__FILE__),'../..','config/document.yml')
		))).result)[::RAILS_ENV]

	def nullify_blank_document_file_name
		self.document_file_name = nil if document_file_name.blank?
	end
end
