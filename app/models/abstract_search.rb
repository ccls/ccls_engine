
#	This is only used in the Abstract app and only seems to use :merged
#	Everything else is unused.

class AbstractSearch < Search

	self.searchable_attributes += [ :q, :merged ]

	self.valid_orders = self.valid_orders.merge({
		:id => 'abstracts.id'
	})

	def abstracts
		@abstracts ||= Abstract.send(
			(paginate?)?'paginate':'all',{
				:order => search_order,
				:joins => joins,
				:conditions => conditions
			}.merge(
				(paginate?)?{
					:per_page => per_page||25,
					:page     => page||1
				}:{}
			)
		)
	end

private	#	THIS IS REQUIRED

	def merged_conditions
#	TODO what if merged is false?
		['abstracts.merged_by_uid IS NOT NULL'] unless merged.blank?
	end

	#	Certainly not the fastest way, but quite possibly the only way
	#	to search against study_subjects being in a separate database.
#
#	TODO StudySubjects are now in the same database as the Abstracts so
#	this unnecessarily complicated searching should be removed.
#
	def study_subjects_conditions
		unless q.blank?
			study_subjects = StudySubject.search(:q => q, :paginate => false)
			study_subject_ids = study_subjects.collect(&:id)
			['abstracts.study_subject_id IN (:study_subject_ids)', 
				{ :study_subject_ids => study_subject_ids } ]
		end
	end

end
