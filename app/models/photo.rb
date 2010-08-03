class Photo < ActiveRecord::Base

	validates_presence_of :title
	validates_length_of :title, :minimum => 4

	has_attached_file :image,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/photo.yml')
		))).result)[Rails.env]

end
