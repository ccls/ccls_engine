
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

	validates_past_date_for :admit_date
	validates_past_date_for :diagnosis_date
	validate :admit_date_is_after_dob
	validate :diagnosis_date_is_after_dob
	validate :subject_is_case

	validates_complete_date_for :admit_date,
		:allow_nil => true
	validates_complete_date_for :diagnosis_date,
		:allow_nil => true

	after_save :update_matching_subjects_reference_date,
		:if => :admit_date_changed?

protected

	def admit_date_is_after_dob
		if !admit_date.blank? && 
			!subject.blank? && 
			!subject.dob.blank? && 
			admit_date < subject.dob
			errors.add(:admit_date, "is before subject's dob.") 
		end
	end

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

	def update_matching_subjects_reference_date
		#	puts "update_matching_subjects_reference_date"
		#	puts "admit_date was:#{admit_date}"
		#	puts "admit_date is:#{admit_date}"
		#	puts "matchingid is blank (FYI)" if subject.try(:identifier).try(:matchingid).blank?
		unless subject.try(:identifier).try(:matchingid).blank?
			#	I would prefer something friendlier, but update_all
			#	doesn't take a :joins option which is mind boggling.
#	TODO
#	I need to sanitize this as it opens a door to a bad place

#			Subject.connection.execute("UPDATE `subjects` " <<
#				"JOIN `identifiers` ON `identifiers`.`study_subject_id` = `subjects`.`id` " <<
#				"SET `reference_date` = '#{admit_date.to_s(:db)}' " <<
#				"WHERE `identifiers`.`matchingid` = '#{subject.identifier.matchingid}'")
			Subject.update_all({:reference_date => admit_date },
				['identifiers.matchingid = ?',subject.identifier.matchingid],
				{ :joins => :identifier })
#			Subject.update_all ..... just don't join.
#UPDATE `subjects` SET `reference_date` = '2010-12-15 12:00:00' WHERE (identifiers.matchingid = '012345')
		end
	end

end
