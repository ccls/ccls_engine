#module GiftCardSearch
#def self.included(base)
##	Must delay the calls to these ActiveRecord methods
##	or it will raise many "undefined method"s.
#base.class_eval do
#
#	def self.valid_search_orders
#		{
#			:id => 'gift_cards.id',
#			:childid => 'study_subjects.childid',
#			:last_name => 'study_subjects.last_name',
#			:first_name => 'study_subjects.first_name',
#			:studyid => 'study_subjects.patid',
#			:number => 'gift_cards.number',
#			:issued_on => 'gift_cards.issued_on'
#		}.with_indifferent_access
#	end
#
#	def self.search(params={})
#		params = params.dup.with_indifferent_access
#		paginate_search = params.has_key?(:paginate) && params[:paginate]
#		per_page = params[:per_page]
#		page = params[:page]
#		q = params.has_key?(:q) && params[:q]
#		conditions = if q.blank?
#			nil
#		else
#			c = []
#			v = {}
#			q.to_s.split(/\s+/).each_with_index do |t,i|
#				c.push("gift_cards.number LIKE :t#{i}")
#				c.push("study_subjects.first_name LIKE :t#{i}")
#				c.push("study_subjects.last_name LIKE :t#{i}")
#				c.push("study_subjects.patid LIKE :t#{i}")
#				c.push("study_subjects.childid LIKE :t#{i}")
#				v["t#{i}".to_sym] = "%#{t}%"
#			end
#			[ "( #{c.join(' OR ')} )", v ]
#		end
#
#		order = params.has_key?(:order) && params[:order]
#		dir = params[:dir]
#		search_order = if valid_search_orders.has_key?(order)
#			order_string = valid_search_orders[order]
#			dir = case dir.try(:downcase)
#				when 'desc' then 'desc'
#				else 'asc'
#			end
#			[order_string,dir].join(' ')
#		else
#			nil
#		end
#
#		GiftCard.send(
#			(paginate_search)?'paginate':'all',{
#				:order => search_order,
#				:joins => "LEFT JOIN study_subjects ON gift_cards.study_subject_id = study_subjects.id",
#				:conditions => conditions
#			}.merge(
#				(paginate_search)?{
#					:per_page => per_page||25,
#					:page     => page||1
#				}:{}
#			)
#		)
#	end
#
#end	#	class_eval
#end	#	included
#end	#	GiftCardSearch
#
#
#__END__

#	This is only ever used in HomeX which is going to go away.


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
	end

#	#	must come before other study_subject related joins
#	def a_subjects_joins
#		"LEFT JOIN study_subjects ON gift_cards.study_subject_id = study_subjects.id" if(
#			%w(childid studyid last_name first_name).include?(@order) )
#	end

end
