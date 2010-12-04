module ResponseExtensions	#	:nodoc:
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			# Same as typing in the class
		end
	end
	
	module ClassMethods	#	:nodoc:
	end
	
	module InstanceMethods
		#	Error for when answer's response_class is not in
		#	( answer string integer float text date time datetime )
		#	Actually, date and time aren't available anymore.
		class InvalidResponseClass < StandardError	#:nodoc:
		end

		#	Return an individual response's question and
		#	answer coded for Home Exposure questionnaire.
		def q_and_a_codes
			q_code = self.question.data_export_identifier

			unless %w( answer string integer float
					text datetime
				).include?(self.answer.response_class)
				raise InvalidResponseClass
			end

			a_code = if self.answer.response_class == "answer"
				self.answer.data_export_identifier
			else
				self.send("#{self.answer.response_class}_value")
			end
			[ q_code, a_code ]
		end

		def q_and_a_codes_and_text
			q_code = self.question.data_export_identifier

			unless %w( answer string integer float
					text datetime
				).include?(self.answer.response_class)
				raise InvalidResponseClass
			end

			a_code = if self.answer.response_class == "answer"
				self.answer.data_export_identifier
			else
				self.send("#{self.answer.response_class}_value")
			end

			a_text = if self.answer.response_class == "answer"
				self.answer.text
			else
				self.send("#{self.answer.response_class}_value")
			end

			q_text = self.question.text

			{ q_code => { :a_code => a_code, :a_text => a_text, :q_text => q_text }}
		end
		alias_method :codes_and_text, :q_and_a_codes_and_text
		
	end
end
