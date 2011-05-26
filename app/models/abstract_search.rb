# don't know exactly
class AbstractSearch < Search

	self.searchable_attributes += [ :q, :merged ]

	self.valid_orders = self.valid_orders.merge({
		:id => 'abstracts.id'
	})

	def abstracts
		require_dependency 'pii.rb'	
		require_dependency 'identifier.rb'
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
		['abstracts.merged_by_uid IS NOT NULL'] unless merged.blank?
	end

	#	Certainly not the fastest way, but quite possibly the only way
	#	to search against subjects being in a separate database.
	def subjects_conditions
		unless q.blank?
			subjects = Subject.search(:q => q, :paginate => false)
			subject_ids = subjects.collect(&:id)
			['abstracts.subject_id IN (:subject_ids)', { :subject_ids => subject_ids } ]
		end
	end

end
