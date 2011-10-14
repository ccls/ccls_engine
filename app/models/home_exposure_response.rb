# Extraction of answers from the survey
class HomeExposureResponse < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject

	validates_presence_of   :study_subject_id
	validates_presence_of   :study_subject
	validates_uniqueness_of :study_subject_id

	def self.fields
		#	db: db field name
		#	human: humanized field
		@@fields ||= YAML::load( ERB.new( IO.read(
			File.join(File.dirname(__FILE__),'../../config/home_exposure_response_fields.yml')
			)).result)
	end

	def self.db_field_names
		fields.collect{|f|f[:db]}
	end

#	get rid of the following and use the above instead

	def self.field_names
		db_field_names
	end

end
