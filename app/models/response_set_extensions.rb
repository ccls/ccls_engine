module ResponseSetExtensions	#	:nodoc:
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			# Same as typing in the class

			belongs_to :subject, :counter_cache => true, :foreign_key => 'study_subject_id'
			has_one :survey_invitation

			validates_presence_of :study_subject_id
		end
	end
	
	module ClassMethods	#	:nodoc:
	end
	
	module InstanceMethods
		#	Collect all of the question and answers coded for
		#	the Home Exposures questionnaire.
		#
		#		>> ResponseSet.last.q_and_a_codes
		#
		#		=> [["how_often_vacuumed_12mos", "1"], 
		#		["freq_grilled_meat_outside_12mos", "2"], 
		#		["other_pest_community_sprayed", "dogs"], 
		#		["year_home_built", 1900], 
		#		["number_of_rooms_in_home", 5]]
		def q_and_a_codes
			self.responses.collect(&:q_and_a_codes)
		end
		
		#	Collect all of the question and answers coded for
		#	the Home Exposures questionnaire.
		#
		#		>> ResponseSet.last.q_and_a_codes_as_attributes
		#
		#		=> {"doneness_of_meat_exterior_12mos"=>"3", 
		#		"number_of_rooms_in_home"=>5, 
		#		"year_home_built"=>1900, 
		#		"cmty_sprayed_other_pest_12mos"=>"1", 
		#		"other_pest_community_sprayed"=>"dogs"}
		#
		#		>> HomeExposureResponse.create(
		#		ResponseSet.find(7).q_and_a_codes_as_attributes)
		def q_and_a_codes_as_attributes
			Hash[*self.responses.collect(&:q_and_a_codes).flatten]
		end

		#	Return a good chunk of info used when merging
		#	response sets into one home exposure response
		def q_and_a_codes_and_text_as_attributes
			h=Hash.new({:a_code => '', :a_text => '(no answer)', :q_text => ''})
			#	h.merge keeps h's defaults!!!  woohoo!
			h.merge(self.responses.collect(&:codes_and_text).inject(:merge)||{})
		end
		alias_method :codes_and_text, :q_and_a_codes_and_text_as_attributes

		#	Compare the Q and A codes of 2 response sets
		#	and return boolean.
		def is_the_same_as?(another_response_set)
			ars = ResponseSet.find(another_response_set)
			(self.q_and_a_codes_as_attributes.diff(
				ars.q_and_a_codes_as_attributes)).blank?
		end

		#	Compare the Q and A codes of 2 response sets
		#	and return hash of differences.
		def diff(another_response_set)
			ars = ResponseSet.find(another_response_set)
			self.q_and_a_codes_as_attributes.diff(ars.q_and_a_codes_as_attributes)
		end

		#	Convert response set to a home exposure questionnaire.
		def to_her
			HomeExposureResponse.create({
				:study_subject_id => self.study_subject_id
			}.merge(self.q_and_a_codes_as_attributes))
		end

		def is_complete?
			#	eventually return the is_complete column value
#			false
			!self.completed_at.nil?
		end
	end
end
