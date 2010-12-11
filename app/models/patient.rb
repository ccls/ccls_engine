
#	DON'T LEAVE THIS HERE AS IT MUCKS UP OTHER STUFF!


#Subject.class_eval do
#	def self.update_all(updates, conditions = nil, options = {})
#		sql  = "UPDATE #{quoted_table_name} SET " <<
#			"#{sanitize_sql_for_assignment(updates)} "
#
#		scope = scope(:find)
#
#		select_sql = ""
#		add_conditions!(select_sql, conditions, scope)
#
#		if options.has_key?(:limit) || (scope && scope[:limit])
#			# Only take order from scope if limit is also provided by scope, this
#			# is useful for updating a has_many association with a limit.
#			add_order!(select_sql, options[:order], scope)
#			add_limit!(select_sql, options, scope)
#			sql.concat(connection.limited_update_conditions(
#				select_sql, quoted_table_name, 
#				connection.quote_column_name(primary_key)))
#		else
#			add_order!(select_sql, options[:order], nil)
#			sql.concat(select_sql)
#		end
#
#		#connection.update(sql, "#{name} Update")
#		sql
#	end
#end

# Patient related subject info.
class Patient < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :organization
	belongs_to :diagnosis

	validates_presence_of   :study_subject_id
	validates_presence_of   :subject
	validates_uniqueness_of :study_subject_id

#	validate :diagnosis_date_is_in_the_past
	validates_past_date_for :diagnosis_date
	validate :diagnosis_date_is_after_dob
	validate :subject_is_case

	validates_complete_date_for :diagnosis_date,
		:allow_nil => true

	after_save :update_matching_subjects_reference_date,
		:if => :diagnosis_date_changed?

protected

#	def diagnosis_date_is_in_the_past
#		if !diagnosis_date.blank? && Time.now < diagnosis_date
#			errors.add(:diagnosis_date, 
#				"is in the future and must be in the past.") 
#		end
#	end

	def diagnosis_date_is_after_dob
		if !diagnosis_date.blank? && 
			!subject.blank? && 
			!subject.dob.blank? && 
			diagnosis_date < subject.dob
			errors.add(:diagnosis_date, "is before subject's dob.") 
		end
	end

	def subject_is_case
		if subject and subject.subject_type.code != 'Case'
		errors.add(:subject,"must be case to have patient info")
		end
	end

#	move me to identifiers
#	actually, this stays here, but the attributes moved to identifiers

#	# https://ccls.lighthouseapp.com/projects/45778/tickets/185
#	# When data is saved, the diagnosis date for the case child 
#	# should be updated and the reference date for all subjects 
#	# whose matchingID is the same as the child subject's 
#	# matchingID should be updated with the new (or revised) 
#	# diagnosis date.
#
	def update_matching_subjects_reference_date
#puts "update_matching_subjects_reference_date"
#puts "diagnosis_date was:#{diagnosis_date_was}"
#puts "diagnosis_date is:#{diagnosis_date}"
#
#puts "matchingid is blank (FYI)" if subject.matchingid.blank?
#
##	unless subject.matchingid.blank?
##puts Subject.update_all({ :reference_date => diagnosis_date },
##		"matchingid = #{subject.matchingid}")
#
	end

end
