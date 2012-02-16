# don't know exactly
class GiftCardSearch < Search

	self.searchable_attributes += [ :q, :number ]

#	self.valid_orders.merge!({  #	NO!
#	@valid_orders.merge!({      #	NO!
	self.valid_orders = self.valid_orders.merge({
		:id => nil,
		:childid => 'study_subjects.childid',
		:last_name => 'study_subjects.last_name',
		:first_name => 'study_subjects.first_name',
		:studyid => 'study_subjects.patid',
		:number => nil,
		:issued_on => nil
	})

	def gift_cards
		@gift_cards ||= GiftCard.send(
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

	def q_conditions
		unless q.blank?
			c = []
			v = {}
			q.to_s.split(/\s+/).each_with_index do |t,i|
				c.push("gift_cards.number LIKE :t#{i}")
				c.push("study_subjects.first_name LIKE :t#{i}")
				c.push("study_subjects.last_name LIKE :t#{i}")
				c.push("study_subjects.patid LIKE :t#{i}")
				c.push("study_subjects.childid LIKE :t#{i}")
				v["t#{i}".to_sym] = "%#{t}%"
			end
			[ "( #{c.join(' OR ')} )", v ]
		end
	end

	def study_subjects_joins
		"LEFT JOIN study_subjects ON gift_cards.study_subject_id = study_subjects.id"
#		"LEFT JOIN study_subjects ON gift_cards.study_subject_id = study_subjects.id " <<
#			"LEFT JOIN piis ON piis.study_subject_id = study_subjects.id " <<
#			"LEFT JOIN identifiers ON identifiers.study_subject_id = study_subjects.id"
	end

#	#	must come before other study_subject related joins
#	def a_subjects_joins
#		"LEFT JOIN study_subjects ON gift_cards.study_subject_id = study_subjects.id" if(
#			%w(childid studyid last_name first_name).include?(@order) )
#	end
#
#	def identifiers_joins
#		"LEFT JOIN identifiers ON identifiers.study_subject_id = study_subjects.id" if (
#			%w(childid studyid).include?(@order) )
#	end
#
#	def piis_joins
#		"LEFT JOIN piis ON piis.study_subject_id = study_subjects.id" if (
#			%w(last_name first_name).include?(@order) )
#	end

end
