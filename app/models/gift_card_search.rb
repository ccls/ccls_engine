# don't know exactly
class GiftCardSearch < Search

	@@searchable_attributes = [ :q, :number ]

	def gift_cards
		@gift_cards ||= GiftCard.send(
			(paginate)?'paginate':'all',{
				:order => order,
				:joins => joins,
				:conditions => conditions
			}.merge(
				(paginate)?{
					:per_page => per_page||25,
					:page     => page||1
				}:{}
			)
		)
	end

	def valid_orders
		%w( id childid last_name first_name studyid 
			number issued_on )
	end

private	#	THIS IS REQUIRED

	#	we should probably keep this more MySQL than Rails

	def order
		if valid_orders.include?(@order)
			order_string = case @order
				when 'childid'    then 'identifiers.childid'
				when 'last_name'  then 'piis.last_name'
				when 'first_name' then 'piis.first_name'
				when 'studyid'    then 'identifiers.patid'
				else @order
			end
			dir = case @dir.try(:downcase)
				when 'desc' then 'desc'
				else 'asc'
			end
			[order_string,dir].join(' ')
		else
			nil
		end
	end

	def q_conditions
		unless q.blank?
			c = []
			v = {}
			q.to_s.split(/\s+/).each_with_index do |t,i|
				c.push("piis.first_name LIKE :t#{i}")
				c.push("piis.last_name LIKE :t#{i}")
				c.push("identifiers.patid LIKE :t#{i}")
				c.push("identifiers.childid LIKE :t#{i}")
				v["t#{i}".to_sym] = "%#{t}%"
			end
			[ "( #{c.join(' OR ')} )", v ]
		end
	end

	def subjects_joins
		"LEFT JOIN subjects ON gift_cards.study_subject_id = subjects.id " <<
			"LEFT JOIN piis ON piis.study_subject_id = subjects.id " <<
			"LEFT JOIN identifiers ON identifiers.study_subject_id = subjects.id"
	end

#	#	must come before other subject related joins
#	def a_subjects_joins
#		"LEFT JOIN subjects ON gift_cards.study_subject_id = subjects.id" if(
#			%w(childid studyid last_name first_name).include?(@order) )
#	end
#
#	def identifiers_joins
#		"LEFT JOIN identifiers ON identifiers.study_subject_id = subjects.id" if (
#			%w(childid studyid).include?(@order) )
#	end
#
#	def piis_joins
#		"LEFT JOIN piis ON piis.study_subject_id = subjects.id" if (
#			%w(last_name first_name).include?(@order) )
#	end

end
