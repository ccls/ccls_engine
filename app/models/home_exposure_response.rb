# Extraction of answers from the survey
class HomeExposureResponse < ActiveRecordShared

	belongs_to :study_subject

	#	NEEDS to be here to match the uniqueness index in the database.
	validates_uniqueness_of :study_subject_id, :allow_nil => true

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

end
